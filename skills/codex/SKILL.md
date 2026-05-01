---
name: codex
description: "Operate Codex CLI; use for exec, resume, review, config, and local troubleshooting."
disable-model-invocation: true
---

# Codex Skill

Current-first. Fast recipes. Verify syntax before use.

## First checks

```bash
codex --version
codex --help
codex exec --help
codex resume --help
codex exec resume --help
codex review --help
```

## Defaults

- prefer `~/.codex/config.toml`
- prefer config/profile over pinning model
- pin `-m gpt-5.4` only if user asked or task needs it
- ask user directly if real choice needed
- no `AskUserQuestion`

## Quick pick

- interactive: `codex`
- one-shot: `codex exec`
- continue session: `codex resume`
- scripted continue: `codex exec resume`
- code review: `codex review`

## Sandbox

- read only: `--sandbox read-only`
- local edits: `--sandbox workspace-write`
- broad / network: `--sandbox danger-full-access`
- use `--skip-git-repo-check` only outside git repo

## Fast recipes

Open interactive:

```bash
codex
codex -C /path/to/repo
```

Analyze repo:

```bash
codex exec --sandbox read-only -C /path/to/repo "Review auth flow. List real risks."
```

Make edits:

```bash
codex exec --sandbox workspace-write --full-auto -C /path/to/repo "Implement the fix."
```

Use live docs/web:

```bash
codex exec --sandbox danger-full-access --search -C /path/to/repo "Verify latest official docs. Update integration."
```

Review diff:

```bash
codex review --uncommitted
codex review --base main
codex review --commit <sha>
```

## Session id

Prefer explicit id. Avoid `--last` in multi-agent work.

Get id from JSON mode. First event is `thread.started`:

```bash
codex exec --json --sandbox read-only -C /path/to/repo "Reply with exactly: ok"
```

Example first line:

```json
{"type":"thread.started","thread_id":"019cf9c0-acb0-70c2-8234-9691d74cad58"}
```

Resume with that id:

```bash
codex resume <id>
codex exec resume <id> "Continue. Give concise summary."
```

## Resume

Interactive:

```bash
codex resume <id>
codex resume <id> "Continue. Finish refactor."
```

Scripted:

```bash
codex exec resume <id> "Continue. Give concise summary."
echo "Continue. Output migration checklist only." | codex exec resume <id> -
```

Notes:

- prefer explicit session id over `--last`
- `--last` risky in multi-agent / parallel sessions
- `codex resume <id>` = best interactive path
- `codex exec resume <id>` = best scripted path
- modern Codex allows flags on resume; do not assume frozen inherited config
- use resume only when same thread/context wanted
- otherwise prefer fresh `codex exec`

## Useful flags

- `-C, --cd <DIR>`
- `-m, --model <MODEL>`
- `-p, --profile <NAME>`
- `--search`
- `--add-dir <DIR>`
- `--full-auto`
- `--json`
- `--ephemeral`
- `-o, --output-last-message <FILE>`

## Output

- prefer `--json` for scripted / agented flows
- prefer `-o <file>` when another tool/process should read final answer
- `2>/dev/null` ok for scripted clean output
- avoid it while debugging
- if user asks for output, relay key lines plainly

Example:

```bash
codex exec --json -o result.txt --sandbox read-only -C /path/to/repo "Summarize migration risks."
```

Extract just the id:

```bash
codex exec --json --sandbox read-only -C /path/to/repo "Reply with exactly: ok" | jq -r 'select(.type=="thread.started") | .thread_id'
```

## Safety

- prefer narrow sandbox
- `--dangerously-bypass-approvals-and-sandbox` last resort only

## Failures

- if help/version fails: stop, report exact issue
- if run fails: quote exact error, likely cause, next move
- if partial: say what finished, what missing

## Trust order

1. local CLI help
2. `https://developers.openai.com/codex`
3. `https://developers.openai.com/codex/config-reference`
4. `https://developers.openai.com/codex/subagents`

## Follow-up

After success, remind user:

```text
codex resume <id>
```

Include the actual session id, not placeholder text, when available.
