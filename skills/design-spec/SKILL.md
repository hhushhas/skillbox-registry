---
name: design-spec
description: Use when the user wants to create or refine a design spec for a feature, architecture change, or implementation plan before coding begins. Especially useful for locking the target shape, domain language, truth status, and execution strategy in a low-reading-overhead format.
disable-model-invocation: true
---

Use this skill to lock the target shape before implementation.
It is not primarily for legacy mapping or migration tracing.

## Defaults

- Mode: `Design`
- Answer density: `balanced`
- Bias: cohesive end-state spec over chronological journaling
- Implementation: hold until the user explicitly approves it
- Lock before broad execution: `Target shape`, `Domain language`, `Truth status`, `Execution strategy`
- Execution planning: dependency-tracked at `phase -> wave -> task`
- Parallel worker model: `gpt-5.3-codex`
- Parallel worker reasoning: `high`
- Worker behavior: prefer finished artifacts or blocker reports over rushed interim summaries

## Core terms

- `Target shape`
  The intended end-state: architecture, ownership, non-goals, and final structure

- `Domain language`
  The shared concepts, distinctions, canonical terms, and vague terms to avoid across discussion, specs, and code

- `Truth status`
  The separation between `Confirmed`, `Inferred`, and `Unknown`

- `Execution strategy`
  The dependency-tracked implementation plan using phases, waves, and tasks

- `Phase`
  Larger execution grouping that contains multiple waves

- `Wave`
  A dependency-aware execution batch with a clear write scope and exit gate

- `Task`
  Smallest execution unit inside a wave, used for sequencing and delegation

## Operating rules

- Prefer one cohesive end-state spec over fragmented journaling
- If the architecture is unclear, stay in `Design`
- Clean up overloaded or fuzzy concepts inside `Domain language`
- Lock canonical terms early enough that implementation does not drift
- Keep `Confirmed`, `Inferred`, and `Unknown` separate
- Lock the execution strategy before broad implementation begins
- Make dependencies explicit enough for safe parallel delegation
- Do not rush worker lanes for premature summaries when the real need is the finished artifact or a precise blocker

## Modes

Every substantial answer should declare one active mode:

- `Design`
- `Execute`
- `Closeout`

If the user does not specify a mode, infer the best one and say so explicitly.

## Standard response format

Use this format for substantial responses.

```md
# Design Spec Status
Mode: Design | Execute | Closeout
Scope: <one sentence>
Status: green | yellow | red
Decision: proceed | hold | blocked

## Summary
- <what is now true>
- <biggest risk>
- <exact next recommendation>

## Target Shape
- what is being built or changed
- intended end-state architecture
- ownership model
- non-goals

## Domain Language
- core concepts
- important distinctions
- canonical terms
- vague or banned terms to avoid

## Truth Status
Confirmed:
- ...

Inferred:
- ...

Unknown:
- ...

## Execution Strategy
### Phase 1: <name>
- goal: ...
- depends on: ...

#### Wave 1.1: <name>
- goal: ...
- depends on: ...
- parallelizable: yes | no

Tasks:
- Task 1: <name> | depends on: ... | write scope: ...
- Task 2: <name> | depends on: ... | write scope: ...

Workers:
- model: `gpt-5.3-codex`
- reasoning: `high`
- behavior: wait for the assigned artifact unless blocked or the user explicitly asks for an interim update

## Closeout
Done:
- ...

Not done:
- ...

Proof:
- `command/result`
- `artifact/result`

Next:
- ...
```

When the user is still shaping the design, `Target Shape`, `Domain Language`, and `Truth Status` are mandatory, and `Execution Strategy` should stop at the first approved implementation wave.

## Formatting rules

- Keep sections short
- No paragraph walls
- No nested bullets
- Prefer concrete names, boundaries, and ownership over vague prose
- Keep each bullet to one idea
- If the answer gets too long, split it into:
  - `Now`
  - `Later`
  - `Appendix`

## Workflow

1. Lock the scope
2. Define the target shape
3. Define the domain language
4. Separate `Confirmed`, `Inferred`, and `Unknown`
5. Define the execution strategy using phases, waves, and tasks
6. Stay in `Design` until the design is agreed
7. Execute only when the user explicitly authorizes implementation
8. Close out with proof and a go / no-go statement

## Judgment

- Make reasonable assumptions and state them
- Ask only when scope, target shape, or implementation approval is materially unclear
- Otherwise keep moving
