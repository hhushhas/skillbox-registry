---
name: dogfood
description: "Use what you built end-to-end as its real user after completing work, whether that is a screen, a CLI, a library or API, CI, infra, a queue or webhook, a skill or agent, a voice call, or a notification, fix the issues and frustrations the pass surfaces, then capture evidence and report honest findings. Use when asked to dogfood, self-test, try it like a user, or prove completed work."
---

# Dogfood

Dogfooding is using what you built the way its user will, not re-running tests. It happens after the feature work but before the handoff gate and commit: its job is to catch and fix what tests and code review miss, before a user ever feels it.

**Roles.** You, the main agent, own the loop: what to drive, judging findings, fixing, deciding when it's clean. Delegate the driving to a subagent when the harness has one, and don't let it read the implementation first. An agent that has seen the code steers around the sharp edges, the same way a developer demoing their own feature does. Hand it the entry point, the flows, and the states; have it capture the pass and report findings with repro steps. It drives and observes; it never fixes. Without subagents, drive it yourself.

## The pass

- Start where the user starts. The install or entry point they'd really use, none of the state you happen to have lying around, no developer shortcuts.
- Walk the whole flow: how the user gets there, the thing itself, and what happens after. Try the obvious wrong input once.
- Hunt the awkward states rather than the happy path: empty, slow, failed, and oversized, plus the ones hiding behind toggles, settings combinations, and different realistic data. If a state is reachable, someone reaches it.
- Go through the front door only, acting on what the user can perceive. What that means depends on the medium; that it holds does not.
- Judge it as a user. Waits, confusing wording, dead ends, and rough edges all count, even when the code is correct.

## Data is most of the work

A pass against an empty account or three rows of `test test` proves almost nothing, and it's the most common way a dogfood ends up worthless. Seeding believable data is part of the pass, not setup you skip: create it through the product itself where you can, or with a seed script where you can't.

Volume changes what you see, so walk the states rather than picking one:

- **None.** First run, before anything exists. This is where the empty state, the fallback copy, and the "what do I do first" moment live, and it's the state every new user starts in.
- **A little.** One or two records. Layouts that were designed full often look broken here, and averages, charts, and summaries do strange things with a sample of one.
- **A realistic middle.** What someone has after a few weeks of ordinary use. Spend most of the pass here, because this is where the user actually lives.
- **A lot.** Enough to strain it. Pagination, scrolling, search, sorting, load times, and truncation all fail at volume and nowhere else.

Vary the shape too, not just the count: long names, non-Latin and right-to-left text, missing optional fields, old and future dates, near-duplicates, and one outlier record far larger than the rest. This applies away from screens as well, where volume means a large input file, a result set past the first page, or a queue with a backlog.

## Drive programmatically, judge by hand

Anything without a screen gets driven by a script, and that's fine. The discipline is that the script only drives. It captures everything the user would perceive (output, errors, exit codes, wall-clock time, artifacts left behind, log lines) and then you read that capture with no rubric and ask whether it's any good. A pass built out of assertions is an integration test: it can only catch what you already thought of, which is exactly the class of problem dogfooding exists to miss less.

## Fix, then go again

The first pass will surface issues; that's it working. That starts with the stack itself: something that won't boot is finding #1, not a blocker to report. Fixes belong to you or your workers, never the driver. Then start over from the beginning, and expect a few iterations before a pass holds up. Where a pass is genuinely expensive (CI minutes, a real phone call, a full apply) batch the fixes instead of iterating one finding at a time.

## Evidence

Working captures stay local files that you read yourself, and every pass gets captured: it's cheap, and it's how you judge findings and confirm fixes. Only the final clean pass becomes evidence, and only that one is shared. Uploading earlier just publishes bugs you were about to remove.

Whatever you hand over, verify it yourself before you do: open the link from outside your own session, play the video, read the transcript. A broken or empty artifact costs the reviewer more than no artifact. The link is the receipt, not the product: a dogfood that delivers a video while its findings sit unfixed has failed at its one job.

## Mediums

Read the one that matches what you built, and read two if you built something that spans them. Each is a set of prompts to think with, not a checklist to complete: the states and findings they name are the ones that recur, never the whole space. What you built will have its own failure modes that no reference here anticipated, and finding those is the point. Everything above still applies.

- `references/screens.md`: web and mobile UI
- `references/cli.md`: CLIs, scripts, anything run from a terminal
- `references/library-and-api.md`: packages, SDKs, public HTTP APIs, and the quickstart that documents them
- `references/automation.md`: CI workflows, cron, queues, webhooks
- `references/infra.md`: IaC, provisioned resources, deploys
- `references/agents-and-skills.md`: skills, system prompts, subagents, MCP servers
- `references/voice.md`: phone and voice agents
- `references/notifications.md`: email, push, anything rendered by someone else's client
