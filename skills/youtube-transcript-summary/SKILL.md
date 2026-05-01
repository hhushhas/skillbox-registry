---
name: youtube-transcript-summary
description: Fetch YouTube video transcripts and summarize what was taught, argued, demoed, or discussed. Use when the user shares a YouTube link or video ID and wants a fast breakdown of the content, key teachings, examples, timestamps, quotes, or practical takeaways without watching the full video.
disable-model-invocation: true
---

# YouTube Transcript Summary

Run the transcript step first. Trust the transcript over memory, guesses, or the video description.

## Quick Start

Run:

```bash
/Users/macmini/.agents/skills/youtube-transcript-summary/scripts/get_youtube_transcript.sh "<youtube-url-or-id>"
```

Use `--json` when structured output would help:

```bash
/Users/macmini/.agents/skills/youtube-transcript-summary/scripts/get_youtube_transcript.sh --json "<youtube-url-or-id>"
```

## Workflow

1. Extract transcript with `scripts/get_youtube_transcript.sh`.
2. Read the output title, author, and timestamped transcript.
3. Answer the user from the transcript itself.
4. Keep quoted language short. Prefer timestamp references over long quotes.
5. If the user asks what was taught, organize the response as:
   - core thesis
   - main points
   - examples/demos
   - practical takeaway

## Output Rules

- State when the answer comes from the transcript.
- Mention the video title and creator when useful.
- If the transcript appears auto-generated or messy, say so briefly.
- If transcript fetch fails, say that directly, then fall back to metadata/web research only if needed.
- Do not invent missing sections.

## Script Notes

- The script accepts a full YouTube URL, `youtu.be` URL, `shorts` URL, `embed` URL, or raw video ID.
- The script bootstraps its dependency into `~/.cache/codex/youtube-transcript-summary` so it does not change the active repo.
- Default output is plain text for fast reading. `--json` is better for downstream parsing.
