---
name: macos-downloads-screenshots-hygiene
description: "Clean macOS files; use for Downloads, screenshots, screen recordings, and Trash recovery."
disable-model-invocation: true
---

# macOS Downloads + Screenshots Hygiene

## Overview

Use this skill for the full local-file hygiene workflow on macOS:

- audit clutter without changing anything first
- rename screenshots into searchable names
- organize `~/Downloads` or screenshot folders into a stable top-level shape
- flag important or hesitant files before deleting
- recover wanted files from `~/.Trash`
- empty Trash safely
- unstick Finder if AppleScript/Trash operations jam it

Keep the workflow reversible until the user clearly wants deletion.

## Workflow

### 1. Start read-only

Before moving or deleting anything:

- inventory counts, large items, obvious duplicates, screenshot batches
- identify personal/business/sensitive files
- identify files that need contextual rename instead of delete
- log progress to `scratchpad/<work>-session-log-YYYY-MM-DD.md`

Prefer shell for normal folders. For Trash, prefer Finder-backed inventory via `scripts/trash_inventory.py`.

### 2. Rename screenshots for retrieval

Use contextual, date-first names:

- screenshots: `YYYY-MM-DD__project-app__surface__topic.ext`
- screen recordings: `YYYY-MM-DD__project-app__surface__topic.mov`
- WhatsApp images: `YYYY-MM-DD__whatsapp__image__HHMMSS.ext`

Rules:

- use filename signal first
- use OCR when generic names like `Screenshot ...`, `SCR-...`, `Screen Shot ...` hide context
- prefer retrieval over perfect prose
- if confidence is low and the user wants speed, still rename with best-guess or broad placeholder rather than keeping garbage names
- include version suffixes only when needed: `-v2`, `-alt2`

Use `scripts/rename_screenshots.swift` for OCR-backed preview/apply passes.

Recommended pass order:

1. high-confidence filenames
2. OCR-backed `SCR-*` / generic screenshot names
3. low-signal leftovers with broad placeholders
4. screen recordings

### 3. Organize Downloads with a stable top-level shape

Use a predictable layout like:

- `01-Apps-Installers`
- `02-Apps-Extracted`
- `03-Archives`
- `04-Documents`
- `05-Images`
- `06-Audio`
- `07-Videos`
- `08-Data`
- `09-Code-Web`
- `10-Chats-Exports`
- `11-Logs-And-Saved-Pages`
- `12-Fonts-And-Assets`
- `13-Extracted-Folders`
- `_review`
- `scratchpad`

Move obvious files first. Put uncertain items in `_review` instead of guessing.

### 4. Flag before deleting

Treat these as hesitant until reviewed:

- keys, certs, `.pem`, `.ppk`, OAuth secrets, API schemas
- chats, PDFs, personal/business records
- extracted app bundles and extracted code folders
- anything with user data, exports, or unclear provenance

If a cleanup pass touched internals of extracted apps/code folders, flag them as potentially damaged. Do not quietly claim they are safe.

### 5. Work with Trash carefully

Important macOS behavior:

- directory listing of `~/.Trash` may be blocked from shell/Python with `Operation not permitted`
- exact known paths like `~/.Trash/<file>` can still be accessible
- Finder/AppleScript can enumerate Trash names even when shell listing is blocked
- large Finder loops over every Trash item, especially with size/kind, can hang Finder

Use:

- `scripts/trash_inventory.py` for counts, filters, and name-based audit
- `scripts/restore_named_from_trash.py` to restore exact files or filtered matches

Preferred Trash flow:

1. audit
2. recover wanted files first
3. rename recovered images/screenshots into date-first names
4. empty Trash only after recovery

### 6. If Finder stops responding

Heavy Trash automation can wedge Finder.

Recovery sequence:

1. inspect stuck `osascript` / Finder processes
2. kill stale `osascript` jobs first
3. `killall Finder`
4. `open -a Finder`
5. verify with lightweight AppleScript only:
   - `osascript -e 'tell application "Finder" to count windows'`
   - `osascript -e 'tell application "Finder" to get name of startup disk'`

Avoid immediately re-running a huge Finder Trash enumeration after relaunch.

## Scripts

### `scripts/trash_inventory.py`

Finder-backed Trash audit.

Examples:

```bash
python3 scripts/trash_inventory.py
python3 scripts/trash_inventory.py --images-only --limit 40
python3 scripts/trash_inventory.py --contains "WhatsApp Image"
python3 scripts/trash_inventory.py --json
```

### `scripts/restore_named_from_trash.py`

Restore by exact name or substring, then optionally normalize WhatsApp image names.

Examples:

```bash
python3 scripts/restore_named_from_trash.py \
  --contains "WhatsApp Image" \
  --dest ~/Downloads/05-Images/Recovered-WhatsApp \
  --whatsapp-date-first

python3 scripts/restore_named_from_trash.py \
  --name "Codex (1).dmg" \
  --dest ~/Downloads/01-Apps-Installers
```

### `scripts/rename_screenshots.swift`

OCR-backed screenshot rename helper.

Examples:

```bash
swift scripts/rename_screenshots.swift --root ~/Desktop/Screenshots --limit 20
swift scripts/rename_screenshots.swift --root ~/Desktop/Screenshots --filter "SCR-" --apply
```

## Operating rules

- prefer read-only audit first unless the user already gave standing permission for renames
- keep screenshot renames moving; do not bottleneck on perfection when the user wants progress
- for deletions or risky cleanup, surface important/hesitant items explicitly
- be honest when a cleanup pass overreached
- never bulk-query Finder Trash item sizes on large piles unless truly needed
