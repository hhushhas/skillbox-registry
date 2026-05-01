# Merge Intel Report Template

Use when you need a manual report (or to sanity-check script output).

## Inputs

- A (source): `<repo path>` @ `<ref>`
- B (target): `<repo path>` @ `<ref>`
- Date: `<YYYY-MM-DD>`
- Output: `MERGE_REPORT_<A>_INTO_<B>_<YYYY-MM-DD>.md`

## Safety

- Non-destructive only
- No patch diffs
- Redact `.env*`, `.npmrc`, `.pypirc`, `**/credentials`, `**/.aws/**`, `**/.ssh/**`, `id_rsa*`, `*.pem`, `*.key`, `*token*`, `*secret*`

## Preflight

- A fetch: ok/failed
- B fetch: ok/failed
- A dirt: `git status --porcelain=v1`
- B dirt: `git status --porcelain=v1`

## Refs (resolved)

- A SHA: `<sha>`
- B SHA: `<sha>`
- Merge-base: `<sha or none>`

## Divergence

- Ahead/behind: `git rev-list --left-right --count B...A`

## Commits

- A not in B: `git log --reverse --oneline B..A`
- B not in A: `git log --reverse --oneline A..B`

## Patch Equivalence

- `git cherry -v B A`
- `git cherry -v A B`

## Range Diff

- `git range-diff <base>..B <base>..A`

## File Summary

- `git diff --stat B...A`
- `git diff --name-status B...A`

## Conflict Hotspots

- Files changed on both sides since merge-base
- Callouts: lockfiles, migrations, `.github/workflows/*`, infra

## No-Loss Strategy

- Backup refs in target repo
- Merge-only (no rebase), optional preview merge (`--no-commit`), abort path

