#!/usr/bin/env python3

import argparse
import collections
import json
import subprocess
import sys


IMAGE_EXTS = {".png", ".jpg", ".jpeg", ".gif", ".webp", ".heic", ".bmp", ".tiff"}


def run_osascript(script):
    result = subprocess.run(["osascript", "-e", script], capture_output=True, text=True)
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip() or "osascript failed")
    return result.stdout.strip()


def get_names(kind):
    output = run_osascript(f'tell application "Finder" to get name of every {kind} of trash')
    if not output:
        return []
    return [name.strip() for name in output.split(",") if name.strip()]


def extension(name):
    lower = name.lower()
    if "." not in lower or lower.startswith("."):
        return "[no-ext]"
    return "." + lower.rsplit(".", 1)[1]


def main():
    parser = argparse.ArgumentParser(description="Finder-backed macOS Trash inventory")
    parser.add_argument("--contains", help="Filter names containing this substring")
    parser.add_argument("--images-only", action="store_true", help="Show image files only")
    parser.add_argument("--limit", type=int, default=80, help="Limit listed names")
    parser.add_argument("--json", action="store_true", help="Emit JSON")
    args = parser.parse_args()

    files = get_names("file")
    folders = get_names("folder")

    names = list(files)
    if args.contains:
        needle = args.contains.lower()
        names = [name for name in names if needle in name.lower()]
    if args.images_only:
        names = [name for name in names if extension(name) in IMAGE_EXTS]

    ext_counts = collections.Counter(extension(name) for name in files)
    summary = {
        "total_items": len(files) + len(folders),
        "files": len(files),
        "folders": len(folders),
        "folders_list": folders,
        "top_extensions": ext_counts.most_common(20),
        "filtered_count": len(names),
        "filtered_names": names[: args.limit],
    }

    if args.json:
        json.dump(summary, sys.stdout, indent=2)
        sys.stdout.write("\n")
        return

    print(f"total_items\t{summary['total_items']}")
    print(f"files\t{summary['files']}")
    print(f"folders\t{summary['folders']}")
    if folders:
        print("folders_list")
        for name in folders:
            print(name)
    print("top_extensions")
    for ext, count in summary["top_extensions"]:
        print(f"{count}\t{ext}")
    print("filtered_names")
    for name in summary["filtered_names"]:
        print(name)


if __name__ == "__main__":
    main()
