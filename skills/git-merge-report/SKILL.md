---
name: git-merge-report
description: Generate a decision-complete Markdown merge-intel report for merging branch/ref A into B (same repo or two repos). Non-destructive inspection only. commit sets, patch-equivalence, diffstat/name-status, conflict hotspots, working-tree dirt, and a no-loss merge strategy.
disable-model-invocation: true
---

# Git Merge Report (Merge Intel)

## Quick Start (copy/paste)

Same repo, branch into branch:

```bash
bash ~/.agents/skills/git-merge-report/scripts/merge-intel-report.sh \
  --a-repo /path/to/repo \
  --a-ref incoming \
  --b-repo /path/to/repo \
  --b-ref main \
  --out-dir "$PWD"
```

Two repos (forks, split apps):

```bash
bash ~/.agents/skills/git-merge-report/scripts/merge-intel-report.sh \
  --a-repo /path/to/repoA \
  --a-ref incoming \
  --b-repo /path/to/repoB \
  --b-ref main \
  --out-dir "$PWD"
```

Output default:

- `MERGE_REPORT_<A>_INTO_<B>_<YYYY-MM-DD>.md`

## Inputs (decision-complete)

Need these inputs (don’t guess):

- `--a-repo`: source repo path (branch/ref you want to merge)
- `--a-ref`: source ref (branch name, tag, or SHA)
- `--b-repo`: target repo path (where merge lands)
- `--b-ref`: target ref (branch name, tag, or SHA)
- Optional: `--out-dir` (default `.`), `--out` (explicit filename), `--date` (override)

Notes:

- Workspace root not a git repo: likely mono folder w/ subrepos. Pass the subrepo directory; `git` resolves the real top-level.
- Script does **not** run `git merge`, `git rebase`, or modify refs in your repos.

## What it Produces

Markdown report with:

- Preflight: repo roots, resolved SHAs, upstream fetch status, working-tree dirt (tracked/untracked)
- Divergence: ahead/behind counts
- Commits in A not in B: `git log --reverse --oneline` ranges
- Patch-equivalence: `git cherry -v` (shows “already applied” vs unique patches)
- Patch series comparison: `git range-diff` (when merge-base exists)
- File-level diff: `git diff --stat`, `git diff --name-status`, plus churn ranking
- **Conflict Hotspots**: files changed on both sides since merge-base + heuristics (lockfiles, migrations, configs)
- **No-Loss Strategy**: safe merge-only steps + backup refs (recommended commands)

## Safety: Redaction Rules (no secrets)

Hard rule: report must be safe to paste in Slack/Notion.

Script redacts:

- Sensitive filenames/paths: `.env*`, `.npmrc`, `.pypirc`, `**/credentials`, `**/.aws/**`, `id_rsa*`, `*.pem`, `*.key`, `*.p12`, `*.jks`, `*.keystore`, `*secrets*`, `*token*`
- Token-like strings in commit subjects or tool output (best-effort):
  - GitHub tokens: `ghp_...`, `github_pat_...`
  - AWS access keys: `AKIA...`
  - Slack tokens: `xox[baprs]-...`
  - Generic bearer tokens: `Bearer ...`
  - OpenAI-style: `sk-...`

Script also avoids high-risk commands:

- No `git diff` full patch output
- No `env`, no `git config --list`, no file content dumps

If you need deeper inspection: do it locally, never in the report.

## Workflow (detailed)

1. Preflight

- Resolve repo roots: `git -C <repo> rev-parse --show-toplevel`
- Optional local safety fetch: `git fetch --all --prune` (best-effort; report notes failures)
- Capture dirt: `git status --porcelain=v1`

2. Compare refs (non-destructive)

- Create temp bare compare repo
- Add both repos as remotes (file path remotes)
- `git fetch --all --prune` into temp repo
- Resolve `A_REF`, `B_REF` to commits
- Compute merge-base (if exists)

3. Collect intel (preferred commands)

- Commits unique:
  - `git log --reverse --oneline B..A`
  - `git log --reverse --oneline A..B`
- Patch equivalence:
  - `git cherry -v B A`
  - `git cherry -v A B`
- Patch-series drift:
  - `git range-diff <base>..B <base>..A`
- File deltas:
  - `git diff --stat B...A`
  - `git diff --name-status B...A`

4. Hotspots + conflict risk

- Files changed on both sides since merge-base
- Highest churn files via `git diff --numstat B...A`
- Highlight risky buckets: lockfiles, migrations, CI configs, infra

5. No-loss merge strategy (recommended)

- Backup refs in target repo
- Merge-only (no rebase), optional dry-run merge

## Report Template

See: `references/report_template.md`
