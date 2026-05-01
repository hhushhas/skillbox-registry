# Redaction Rules (Merge Intel Reports)

Goal: report safe to paste into Slack/Notion. No secrets. No tokens. No file contents.

## Never include

- Any `.env*` content
- Any `.npmrc` content
- Any credential files content (`**/credentials`, `**/.aws/**`, `**/.ssh/**`, etc.)
- Any patch diffs (`git diff` without `--stat/--name-status/--numstat`)
- Any `env` output / exported variables
- Any `git config --list`

## Path redaction (filenames)

If a file path matches any of these, redact to `<REDACTED:PATH>`:

- `.env`, `.env.*`
- `.npmrc`, `.pypirc`
- `**/.aws/**`, `**/.ssh/**`, `**/.config/gh/**`, `**/.config/gcloud/**`
- `id_rsa*`, `*.pem`, `*.key`, `*.p12`, `*.jks`, `*.keystore`
- `*credentials*`, `*token*`, `*secret*` (case-sensitive in the script; be conservative manually)

## Token-like string redaction (text)

Redact if you see these patterns in commit subjects or tool output:

- GitHub: `ghp_...`, `github_pat_...`
- AWS access key id: `AKIA...`
- Slack: `xox[baprs]-...`
- Bearer: `Bearer ...`
- OpenAI-style: `sk-...`

If in doubt: replace the entire substring with `<REDACTED>`.

