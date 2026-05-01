#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  get_youtube_transcript.sh [--json] <youtube-url-or-id>

Examples:
  get_youtube_transcript.sh "https://youtu.be/SPGc3RM3V80"
  get_youtube_transcript.sh --json "SPGc3RM3V80"
EOF
}

mode="text"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --json)
      mode="json"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      break
      ;;
  esac
done

if [[ $# -lt 1 ]]; then
  usage >&2
  exit 1
fi

input="$1"

video_id="$(
python3 - "$input" <<'PY'
import re
import sys
from urllib.parse import parse_qs, urlparse

value = sys.argv[1].strip()

if re.fullmatch(r"[\w-]{11}", value):
    print(value)
    raise SystemExit

if not re.match(r"^https?://", value):
    value = "https://" + value

parsed = urlparse(value)
host = parsed.netloc.lower()
path = parsed.path.strip("/")

video_id = ""

if "youtu.be" in host:
    video_id = path.split("/")[0]
elif "youtube.com" in host or "youtube-nocookie.com" in host:
    if parsed.path == "/watch":
        video_id = parse_qs(parsed.query).get("v", [""])[0]
    else:
        parts = [part for part in path.split("/") if part]
        if len(parts) >= 2 and parts[0] in {"shorts", "embed", "live"}:
            video_id = parts[1]

if not re.fullmatch(r"[\w-]{11}", video_id):
    raise SystemExit("Could not extract a valid YouTube video ID")

print(video_id)
PY
)"

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/codex/youtube-transcript-summary"
mkdir -p "$cache_dir"

if [[ ! -f "$cache_dir/package.json" ]]; then
  cat >"$cache_dir/package.json" <<'EOF'
{
  "name": "youtube-transcript-summary-cache",
  "private": true,
  "type": "module",
  "dependencies": {
    "youtube-transcript": "^1.3.0"
  }
}
EOF
fi

if [[ ! -d "$cache_dir/node_modules/youtube-transcript" ]]; then
  (
    cd "$cache_dir"
    bun install --silent >/dev/null
  )
fi

runner="$cache_dir/fetch_transcript.mjs"

if [[ ! -f "$runner" ]]; then
  cat >"$runner" <<'NODE'
const videoId = process.env.VIDEO_ID;
const outputMode = process.env.OUTPUT_MODE;

if (!videoId) {
  console.error("Missing VIDEO_ID");
  process.exit(1);
}

const videoUrl = `https://www.youtube.com/watch?v=${videoId}`;
const oembedUrl = `https://www.youtube.com/oembed?url=${encodeURIComponent(videoUrl)}&format=json`;

async function fetchMetadata() {
  try {
    const response = await fetch(oembedUrl);
    if (!response.ok) return null;
    return await response.json();
  } catch {
    return null;
  }
}

try {
  const [{ YoutubeTranscript }, metadata] = await Promise.all([
    import("youtube-transcript"),
    fetchMetadata(),
  ]);

  const transcript = await YoutubeTranscript.fetchTranscript(videoId);
  const normalized = transcript.map((row) => ({
    text: row.text,
    offsetMs: row.offset,
    durationMs: row.duration,
    timestamp: new Date(row.offset).toISOString().slice(14, 19),
  }));

  const payload = {
    videoId,
    url: videoUrl,
    title: metadata?.title ?? null,
    author: metadata?.author_name ?? null,
    transcript: normalized,
  };

  if (outputMode === "json") {
    console.log(JSON.stringify(payload, null, 2));
    process.exit(0);
  }

  console.log(`Title: ${payload.title ?? "(unknown)"}`);
  console.log(`Author: ${payload.author ?? "(unknown)"}`);
  console.log(`Video ID: ${payload.videoId}`);
  console.log(`URL: ${payload.url}`);
  console.log("");

  for (const row of normalized) {
    console.log(`[${row.timestamp}] ${row.text}`);
  }
} catch (error) {
  console.error(`Transcript fetch failed: ${error instanceof Error ? error.message : String(error)}`);
  process.exit(1);
}
NODE
fi

(
  cd "$cache_dir"
  VIDEO_ID="$video_id" OUTPUT_MODE="$mode" bun "$runner"
)
