#!/usr/bin/env python3
"""
Minimal ElevenLabs TTS helper for short client voice notes.
"""

from __future__ import annotations

import argparse
import json
import os
import sys
import urllib.error
import urllib.request
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--voice-id", required=True)
    parser.add_argument("--text-file", required=True)
    parser.add_argument("--output", required=True)
    parser.add_argument("--model", default="eleven_v3")
    parser.add_argument("--api-key")
    parser.add_argument("--stability", type=float, default=0.42)
    parser.add_argument("--similarity-boost", type=float, default=0.86)
    parser.add_argument("--style", type=float, default=0.48)
    parser.add_argument("--speaker-boost", action="store_true", default=True)
    parser.add_argument("--no-speaker-boost", dest="speaker_boost", action="store_false")
    parser.add_argument("--output-format", default="mp3_44100_128")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    api_key = args.api_key or os.environ.get("ELEVENLABS_API_KEY")
    if not api_key:
        print("Missing ELEVENLABS_API_KEY or --api-key", file=sys.stderr)
        return 1

    text = Path(args.text_file).read_text(encoding="utf-8")
    payload = {
        "text": text,
        "model_id": args.model,
        "voice_settings": {
            "stability": args.stability,
            "similarity_boost": args.similarity_boost,
            "style": args.style,
            "use_speaker_boost": args.speaker_boost,
        },
    }

    url = (
        f"https://api.elevenlabs.io/v1/text-to-speech/{args.voice_id}"
        f"?output_format={args.output_format}"
    )
    req = urllib.request.Request(
        url,
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "xi-api-key": api_key,
            "Content-Type": "application/json",
        },
        method="POST",
    )

    try:
        with urllib.request.urlopen(req) as response:
            audio = response.read()
    except urllib.error.HTTPError as exc:
        body = exc.read().decode("utf-8", errors="replace")
        print(body, file=sys.stderr)
        return 1

    output = Path(args.output)
    output.write_bytes(audio)
    print(output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
