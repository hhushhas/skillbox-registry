#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
merge-intel-report.sh

Generate a Markdown merge-intel report for merging A into B.
Non-destructive inspection only. Safe output (redaction rules applied).

Required:
  --a-repo PATH      Source repo path (the branch/ref you want to merge)
  --a-ref  REF       Source ref (branch/tag/SHA)
  --b-repo PATH      Target repo path (where merge lands)
  --b-ref  REF       Target ref (branch/tag/SHA)

Optional:
  --out-dir PATH       Output directory (default: .)
  --out PATH           Output filename override
  --date YYYY-MM-DD    Date override (default: today)
  -h|--help            Help

Default output name:
  MERGE_REPORT_<A>_INTO_<B>_<YYYY-MM-DD>.md
USAGE
}

A_REPO=""
A_REF=""
B_REPO=""
B_REF=""
OUT_DIR="."
OUT_FILE=""
REPORT_DATE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --a-repo) A_REPO="${2:-}"; shift 2 ;;
    --a-ref) A_REF="${2:-}"; shift 2 ;;
    --b-repo) B_REPO="${2:-}"; shift 2 ;;
    --b-ref) B_REF="${2:-}"; shift 2 ;;
    --out-dir) OUT_DIR="${2:-}"; shift 2 ;;
    --out) OUT_FILE="${2:-}"; shift 2 ;;
    --date) REPORT_DATE="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "unknown arg: $1" >&2; usage; exit 2 ;;
  esac
done

if [[ -z "$A_REPO" || -z "$A_REF" || -z "$B_REPO" || -z "$B_REF" ]]; then
  echo "missing required args" >&2
  usage
  exit 2
fi

if [[ -z "$REPORT_DATE" ]]; then
  REPORT_DATE="$(date +%F)"
fi

mkdir -p "$OUT_DIR"

sanitize_token() {
  echo "$1" | tr '[:lower:]' '[:upper:]' | sed -E 's#[^A-Z0-9]+#_#g; s#^_+##; s#_+$##'
}

path_is_sensitive() {
  local p="$1"
  case "$p" in
    .env|.env.*|*/.env|*/.env.*) return 0 ;;
    .npmrc|*/.npmrc) return 0 ;;
    .pypirc|*/.pypirc) return 0 ;;
    */.aws/*|*/.config/gcloud/*|*/.config/gh/*|*/.ssh/*) return 0 ;;
    *credentials*|*credential*) return 0 ;;
    id_rsa|id_rsa.*|*/id_rsa|*/id_rsa.*) return 0 ;;
    *.pem|*.key|*.p12|*.jks|*.keystore) return 0 ;;
    *secret*|*secrets*|*token*|*tokens*) return 0 ;;
  esac
  return 1
}

redact_path() {
  local p="$1"
  if path_is_sensitive "$p"; then
    echo "<REDACTED:PATH>"
  else
    echo "$p"
  fi
}

redact_text() {
  # Best-effort token redaction in arbitrary text.
  # Keep conservative; avoid mangling normal content.
  sed -E \
    -e 's#(^|[^A-Za-z0-9_])(\.env(\.[A-Za-z0-9._-]+)?)#\1<REDACTED:FILENAME>#g' \
    -e 's#(^|[^A-Za-z0-9_])(\.npmrc)#\1<REDACTED:FILENAME>#g' \
    -e 's#(^|[^A-Za-z0-9_])(\.pypirc)#\1<REDACTED:FILENAME>#g' \
    -e 's/(ghp_)[A-Za-z0-9]{10,}/\1<REDACTED>/g' \
    -e 's/(github_pat_)[A-Za-z0-9_]{10,}/\1<REDACTED>/g' \
    -e 's/AKIA[0-9A-Z]{16}/AKIA<REDACTED>/g' \
    -e 's/(xox[baprs]-)[0-9A-Za-z-]{10,}/\1<REDACTED>/g' \
    -e 's/(Bearer )[A-Za-z0-9._~+\/-]+=*/\1<REDACTED>/g' \
    -e 's/(sk-)[A-Za-z0-9]{10,}/\1<REDACTED>/g' \
    -e 's/(CLOUDFLARE|CLOUDFLARE_API|CF)_?(TOKEN|KEY)[^[:space:]]*/\1_\2<REDACTED>/g'
}

COMMANDS_RUN=""
log_cmd() {
  local rendered=""
  local arg
  for arg in "$@"; do
    rendered+=$(printf '%q ' "$arg")
  done
  COMMANDS_RUN+="${rendered% }"$'\n'
}
run_cmd() {
  log_cmd "$@"
  "$@"
}

git_top() {
  local repo="$1"
  git -C "$repo" rev-parse --show-toplevel 2>/dev/null || true
}

git_try_fetch_all() {
  local repo="$1"
  if git -C "$repo" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    if git -C "$repo" fetch --all --prune --tags >/dev/null 2>&1; then
      echo "ok"
    else
      echo "failed"
    fi
  else
    echo "not-a-repo"
  fi
}

git_status_porcelain() {
  local repo="$1"
  if git -C "$repo" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git -C "$repo" status --porcelain=v1 2>/dev/null || true
  fi
}

redact_status_block() {
  # porcelain v1: XY<space>PATH (PATH can include spaces). For renames: "old -> new".
  local line xy rest
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    xy="${line:0:2}"
    rest="${line:3}"
    if [[ "$rest" == *" -> "* ]]; then
      local old="${rest%% -> *}"
      local new="${rest##* -> }"
      printf '%s %s -> %s\n' "$xy" "$(redact_path "$old")" "$(redact_path "$new")"
    else
      printf '%s %s\n' "$xy" "$(redact_path "$rest")"
    fi
  done
}

mktemp_dir() {
  mktemp -d -t merge-intel.XXXXXX
}

A_TOP="$(git_top "$A_REPO")"
B_TOP="$(git_top "$B_REPO")"

if [[ -z "$A_TOP" ]]; then
  echo "A repo not a git repo: $A_REPO" >&2
  echo "tip: workspace root not a repo? pass the subrepo directory." >&2
  exit 2
fi
if [[ -z "$B_TOP" ]]; then
  echo "B repo not a git repo: $B_REPO" >&2
  echo "tip: workspace root not a repo? pass the subrepo directory." >&2
  exit 2
fi

A_FETCH_STATUS="$(git_try_fetch_all "$A_TOP")"
B_FETCH_STATUS="$(git_try_fetch_all "$B_TOP")"

A_STATUS_RAW="$(git_status_porcelain "$A_TOP")"
B_STATUS_RAW="$(git_status_porcelain "$B_TOP")"

TMP_DIR="$(mktemp_dir)"
COMPARE_REPO="$TMP_DIR/compare.git"
mkdir -p "$COMPARE_REPO"

run_cmd git init --bare "$COMPARE_REPO" >/dev/null 2>&1
run_cmd git -C "$COMPARE_REPO" remote add A "$A_TOP"
run_cmd git -C "$COMPARE_REPO" remote add B "$B_TOP"
run_cmd git -C "$COMPARE_REPO" fetch --all --prune --tags --quiet >/dev/null 2>&1

resolve_ref() {
  local repo_top="$1"
  local remote="$2"
  local ref="$3"

  # Prefer resolving from the actual repo. Supports remote-tracking refs like origin/foo.
  if git -C "$repo_top" rev-parse --verify "$ref^{commit}" >/dev/null 2>&1; then
    git -C "$repo_top" rev-parse "$ref^{commit}"
    return 0
  fi

  # Fallback: resolve from fetched refs in the temp compare repo.
  if git -C "$COMPARE_REPO" rev-parse --verify "refs/remotes/$remote/$ref^{commit}" >/dev/null 2>&1; then
    git -C "$COMPARE_REPO" rev-parse "refs/remotes/$remote/$ref^{commit}"
    return 0
  fi
  if git -C "$COMPARE_REPO" rev-parse --verify "refs/tags/$ref^{commit}" >/dev/null 2>&1; then
    git -C "$COMPARE_REPO" rev-parse "refs/tags/$ref^{commit}"
    return 0
  fi
  if git -C "$COMPARE_REPO" rev-parse --verify "$ref^{commit}" >/dev/null 2>&1; then
    git -C "$COMPARE_REPO" rev-parse "$ref^{commit}"
    return 0
  fi
  return 1
}

A_SHA="$(resolve_ref "$A_TOP" A "$A_REF" || true)"
B_SHA="$(resolve_ref "$B_TOP" B "$B_REF" || true)"

if [[ -z "$A_SHA" ]]; then
  echo "cannot resolve A ref: $A_REF" >&2
  rm -rf "$TMP_DIR" || true
  exit 2
fi
if [[ -z "$B_SHA" ]]; then
  echo "cannot resolve B ref: $B_REF" >&2
  rm -rf "$TMP_DIR" || true
  exit 2
fi

MERGE_BASE="$(git -C "$COMPARE_REPO" merge-base "$A_SHA" "$B_SHA" 2>/dev/null || true)"

A_LABEL="$(sanitize_token "$A_REF")"
B_LABEL="$(sanitize_token "$B_REF")"
if [[ -z "$OUT_FILE" ]]; then
  OUT_FILE="MERGE_REPORT_${A_LABEL}_INTO_${B_LABEL}_${REPORT_DATE}.md"
fi
OUT_PATH="$OUT_DIR/$OUT_FILE"

SAFE_A_BACKUP="backup/merge-${REPORT_DATE}-${A_LABEL}"
SAFE_B_BACKUP="backup/merge-${REPORT_DATE}-${B_LABEL}"

NO_LOSS_MERGE_REF="$A_REF"
NO_LOSS_XREPO_BLOCK=""
if [[ "$A_TOP" != "$B_TOP" ]]; then
  NO_LOSS_MERGE_REF="source/${A_REF}"
  NO_LOSS_XREPO_BLOCK="$(cat <<EOF
git remote add source "${A_TOP}" || true
git fetch source --prune

# merge with: source/<branch>
EOF
)"
  NO_LOSS_XREPO_BLOCK+=$'\n'
fi

count_ahead_behind() {
  git -C "$COMPARE_REPO" rev-list --left-right --count "$B_SHA...$A_SHA" 2>/dev/null || echo -e "0\t0"
}
AB_COUNTS="$(count_ahead_behind)"
BEHIND_COUNT="${AB_COUNTS%%$'\t'*}"
AHEAD_COUNT="${AB_COUNTS##*$'\t'}"

log_range_oneline() {
  local range="$1"
  git -C "$COMPARE_REPO" log --reverse --oneline --no-decorate "$range" 2>/dev/null || true
}

cherry_block() {
  local upstream="$1" head="$2"
  git -C "$COMPARE_REPO" cherry -v "$upstream" "$head" 2>/dev/null || true
}

range_diff_block() {
  local base="$1" old="$2" new="$3"
  [[ -z "$base" ]] && return 0
  git -C "$COMPARE_REPO" range-diff --no-color "$base..$old" "$base..$new" 2>/dev/null || true
}

diff_stat() { git -C "$COMPARE_REPO" diff --stat "$B_SHA...$A_SHA" 2>/dev/null || true; }
diff_name_status() { git -C "$COMPARE_REPO" diff --name-status "$B_SHA...$A_SHA" 2>/dev/null || true; }
diff_numstat() { git -C "$COMPARE_REPO" diff --numstat "$B_SHA...$A_SHA" 2>/dev/null || true; }

files_changed_since() {
  local base="$1" head="$2"
  [[ -z "$base" ]] && return 0
  git -C "$COMPARE_REPO" diff --name-only "$base..$head" 2>/dev/null || true
}

redact_log_block() {
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    printf '%s\n' "$line" | redact_text
  done
}

redact_name_status_block() {
  local status p1 p2
  while IFS=$'\t' read -r status p1 p2; do
    [[ -z "${status:-}" ]] && continue
    if [[ -n "${p2:-}" ]]; then
      printf '%s\t%s\t%s\n' "$status" "$(redact_path "$p1")" "$(redact_path "$p2")"
    else
      printf '%s\t%s\n' "$status" "$(redact_path "$p1")"
    fi
  done
}

redact_stat_block() {
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    if echo "$line" | grep -E -q '(^|/)(\.env(\.|$)|\.npmrc$|\.pypirc$|id_rsa(\.|$)|[^ ]+\.(pem|key|p12|jks|keystore))'; then
      echo "$line" | sed -E 's#^([^|]+)\|#<REDACTED:PATH> |#' | redact_text
    else
      echo "$line" | redact_text
    fi
  done
}

rank_hot_files() {
  diff_numstat | awk -F '\t' 'BEGIN{OFS="\t"} {a=$1; d=$2; p=$3; if (a=="-") a=0; if (d=="-") d=0; s=a+d; print s,p}' \
    | sort -nr \
    | head -n 25
}

HOTSPOT_FILES=""
if [[ -n "$MERGE_BASE" ]]; then
  A_FILES="$(files_changed_since "$MERGE_BASE" "$A_SHA" | LC_ALL=C sort -u)"
  B_FILES="$(files_changed_since "$MERGE_BASE" "$B_SHA" | LC_ALL=C sort -u)"
  HOTSPOT_FILES="$(comm -12 <(printf '%s\n' "$A_FILES") <(printf '%s\n' "$B_FILES") | sed '/^$/d' || true)"
fi

risky_bucket_hits() {
  local f
  while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    case "$f" in
      */package.json|package.json|*/bun.lockb|bun.lockb|*/yarn.lock|yarn.lock|*/pnpm-lock.yaml|pnpm-lock.yaml|*/package-lock.json|package-lock.json)
        echo -e "deps/lockfile\t$(redact_path "$f")" ;;
      */.github/workflows/*|.github/workflows/*)
        echo -e "ci\t$(redact_path "$f")" ;;
      */terraform/*|terraform/*|*/infra/*|infra/*|*/k8s/*|k8s/*|*/docker/*|docker/*|Dockerfile|*/Dockerfile)
        echo -e "infra\t$(redact_path "$f")" ;;
      */migrations/*|migrations/*|*/prisma/migrations/*|prisma/migrations/*|*/db/migrate/*|db/migrate/*)
        echo -e "migrations\t$(redact_path "$f")" ;;
      */amplify.yml|amplify.yml|*/.ebextensions/*|.ebextensions/*)
        echo -e "deploy\t$(redact_path "$f")" ;;
    esac
  done
}

# Write report. Keep stdout for final OUT_PATH print.
exec 3>&1
exec >"$OUT_PATH"

cat <<EOF
# Merge Intel Report: ${A_REF} -> ${B_REF}

Date: ${REPORT_DATE}

## Inputs

- A (source): \`${A_TOP}\` @ \`${A_REF}\`
- B (target): \`${B_TOP}\` @ \`${B_REF}\`
- Output: \`${OUT_PATH}\`

## Safety

- Non-destructive inspection only. No merges/rebases. No ref updates in your repos.
- Redaction: sensitive paths + token-like strings removed.
- No patch diffs. Only stats + filenames (with redaction).

Redaction rules: \`.env*\`, \`.npmrc\`, \`.pypirc\`, \`**/credentials\`, \`**/.aws/**\`, \`**/.ssh/**\`, \`id_rsa*\`, \`*.pem\`, \`*.key\`, \`*token*\`, \`*secret*\`.

## Preflight

### Repo A

- Top: \`${A_TOP}\`
- Local fetch (\`git fetch --all --prune --tags\`): \`${A_FETCH_STATUS}\`
- Dirt (\`git status --porcelain\`):

\`\`\`
EOF
printf '%s\n' "$A_STATUS_RAW" | redact_status_block | redact_text
cat <<EOF
\`\`\`

### Repo B

- Top: \`${B_TOP}\`
- Local fetch (\`git fetch --all --prune --tags\`): \`${B_FETCH_STATUS}\`
- Dirt (\`git status --porcelain\`):

\`\`\`
EOF
printf '%s\n' "$B_STATUS_RAW" | redact_status_block | redact_text
cat <<EOF
\`\`\`

## Refs (resolved)

- A SHA: \`${A_SHA}\`
- B SHA: \`${B_SHA}\`
- Merge-base: \`${MERGE_BASE:-<none>}\`

## Divergence

- A ahead of B (commits): \`${AHEAD_COUNT}\`
- A behind B (commits): \`${BEHIND_COUNT}\`

Interpretation:
- \`ahead\`: commits you’d introduce when merging A into B
- \`behind\`: commits already in B but not in A

## Commits in A not in B

Command: \`git log --reverse --oneline B..A\`

\`\`\`
EOF
log_range_oneline "$B_SHA..$A_SHA" | redact_log_block
cat <<EOF
\`\`\`

## Commits in B not in A

Command: \`git log --reverse --oneline A..B\`

\`\`\`
EOF
log_range_oneline "$A_SHA..$B_SHA" | redact_log_block
cat <<EOF
\`\`\`

## Patch Equivalence (already-applied detection)

\`git cherry -v B A\`

- \`+\` unique patch (not in upstream)
- \`-\` patch-equivalent commit already in upstream

\`\`\`
EOF
cherry_block "$B_SHA" "$A_SHA" | redact_text
cat <<EOF
\`\`\`

\`git cherry -v A B\`

\`\`\`
EOF
cherry_block "$A_SHA" "$B_SHA" | redact_text
cat <<EOF
\`\`\`

## Range Diff (patch-series drift)

Command: \`git range-diff <base>..B <base>..A\`

EOF
if [[ -z "$MERGE_BASE" ]]; then
  echo "- No merge-base found. Skipping range-diff (unrelated histories)."
else
  echo '```'
  range_diff_block "$MERGE_BASE" "$B_SHA" "$A_SHA" | redact_text
  echo '```'
fi

cat <<EOF

## File Diff Summary

Command: \`git diff --stat B...A\`

\`\`\`
EOF
diff_stat | redact_stat_block
cat <<EOF
\`\`\`

Command: \`git diff --name-status B...A\`

\`\`\`
EOF
diff_name_status | redact_name_status_block | redact_text
cat <<EOF
\`\`\`

## Hot Files (churn)

Command: \`git diff --numstat B...A\` (ranked by added+deleted)

\`\`\`
EOF
rank_hot_files | while IFS=$'\t' read -r score path; do
  [[ -z "${score:-}" || -z "${path:-}" ]] && continue
  printf '%s\t%s\n' "$score" "$(redact_path "$path")"
done | redact_text
cat <<EOF
\`\`\`

## Conflict Hotspots

Definition: files changed on both sides since merge-base.

EOF
if [[ -z "$MERGE_BASE" ]]; then
  echo "- No merge-base. Treat as high-risk. Prefer manual integration or import strategy."
else
  echo "- Merge-base: \`${MERGE_BASE}\`"
  echo
  echo "Files changed on both sides (likely conflicts):"
  echo
  echo '```'
  if [[ -n "$HOTSPOT_FILES" ]]; then
    printf '%s\n' "$HOTSPOT_FILES" | while IFS= read -r f; do redact_path "$f"; done
  else
    echo "(none detected)"
  fi
  echo '```'
  echo
  echo "Risk buckets (subset):"
  echo
  echo '```'
  printf '%s\n' "$HOTSPOT_FILES" | risky_bucket_hits | sed '/^$/d' || true
  echo '```'
fi

cat <<EOF

## No-Loss Strategy (recommended)

Goal: merge-only + backups. Zero loss, easy rollback.

In target repo (B):

\`\`\`bash
cd "${B_TOP}"

git fetch --all --prune

# Backup refs (namespaced; keep until validated)
git branch "${SAFE_B_BACKUP}" "${B_REF}"
git branch "${SAFE_A_BACKUP}" "${A_REF}" || true

# Safer preview (creates merge state without committing). Abort if ugly.
${NO_LOSS_XREPO_BLOCK}git merge --no-ff --no-commit "${NO_LOSS_MERGE_REF}" || true
# inspect, resolve if needed
# git merge --abort

# if good: commit the merge
# git commit
\`\`\`

If A and B are different repos:
- Add A as a remote in B (or use a temporary remote), fetch, then merge the remote-tracking branch.
- Still keep backup refs first.

## Commands Run (this script)

(Recorded for reproducibility; no secrets)

\`\`\`
EOF
printf '%s' "$COMMANDS_RUN" | redact_text
cat <<EOF
\`\`\`
EOF

exec >&3
rm -rf "$TMP_DIR" || true
echo "$OUT_PATH"
