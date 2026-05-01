#!/usr/bin/env python3

import argparse
import os
import re
import shutil
import subprocess
import sys


def run_osascript(script):
    result = subprocess.run(["osascript", "-e", script], capture_output=True, text=True)
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip() or "osascript failed")
    return result.stdout.strip()


def get_trash_file_names():
    output = run_osascript('tell application "Finder" to get name of every file of trash')
    if not output:
        return []
    return [name.strip() for name in output.split(",") if name.strip()]


def whatsapp_name(old_name):
    match = re.match(
        r"^WhatsApp Image (\d{4})-(\d{2})-(\d{2}) at (\d{2})\.(\d{2})\.(\d{2})(?: \((\d+)\))?\.(\w+)$",
        old_name,
        re.I,
    )
    if not match:
        return None
    year, month, day, hour, minute, second, dup, ext = match.groups()
    stem = f"{year}-{month}-{day}__whatsapp__image__{hour}{minute}{second}"
    if dup:
        stem += f"-v{int(dup) + 1}"
    return f"{stem}.{ext.lower()}"


def unique_path(path):
    if not os.path.exists(path):
        return path
    stem, ext = os.path.splitext(path)
    version = 2
    candidate = f"{stem}-alt{version}{ext}"
    while os.path.exists(candidate):
        version += 1
        candidate = f"{stem}-alt{version}{ext}"
    return candidate


def main():
    parser = argparse.ArgumentParser(description="Restore named files from macOS Trash")
    parser.add_argument("--dest", required=True, help="Destination directory")
    parser.add_argument("--name", action="append", default=[], help="Exact file name to restore")
    parser.add_argument("--contains", action="append", default=[], help="Substring match against Trash file names")
    parser.add_argument("--whatsapp-date-first", action="store_true", help="Normalize WhatsApp Image names")
    parser.add_argument("--dry-run", action="store_true", help="Preview without moving")
    args = parser.parse_args()

    all_names = get_trash_file_names()
    selected = set(args.name)
    if args.contains:
        needles = [needle.lower() for needle in args.contains]
        for name in all_names:
            lower = name.lower()
            if any(needle in lower for needle in needles):
                selected.add(name)

    if not selected:
        print("No matching Trash files.")
        return

    dest = os.path.expanduser(args.dest)
    if not args.dry_run:
        os.makedirs(dest, exist_ok=True)

    trash_dir = os.path.expanduser("~/.Trash")
    restored = 0
    missing = 0

    for old_name in sorted(selected):
        source = os.path.join(trash_dir, old_name)
        target_name = whatsapp_name(old_name) if args.whatsapp_date_first else old_name
        if not target_name:
            target_name = old_name
        target_path = unique_path(os.path.join(dest, target_name))
        if not os.path.exists(source):
            missing += 1
            print(f"MISSING\t{old_name}")
            continue
        if args.dry_run:
            print(f"DRYRUN\t{old_name}\t=>\t{os.path.basename(target_path)}")
            continue
        shutil.move(source, target_path)
        restored += 1
        print(f"RESTORED\t{old_name}\t=>\t{os.path.basename(target_path)}")

    print(f"SUMMARY\trestored\t{restored}\tmissing\t{missing}")


if __name__ == "__main__":
    main()
