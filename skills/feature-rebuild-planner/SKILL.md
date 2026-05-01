---
name: feature-rebuild-planner
description: "Plan feature rebuilds; use for strip-outs, replacements, migrations, and accepted blast radius."
disable-model-invocation: true
---

# Feature Rebuild Planner

Use this skill when the user wants:

- a full strip-out rebuild of an existing feature
- a clean target architecture instead of a compatibility migration
- accepted breaking changes and large blast radius
- old feature behavior excavated, judged, and selectively kept
- no ambiguity between the user and the agent before execution
- a stable, low-reading-overhead planning format

This skill is for rebuilds where the current feature is evidence, not the source of truth.

## Locked defaults

- Default unit of work: `feature surface`
- Default stance: `destructive-clean rebuild`
- Default mode: `Excavate` plus `Design` unless the user explicitly asks to execute
- Do not implement until the user explicitly approves `Execute`
- Breaking internal APIs, folder structure, service boundaries, DTOs, routes, tool contracts, storage flows, and naming is allowed by default
- Compatibility is opt-in and must be scoped
- Preserve only explicitly protected external contracts, data, security, billing, audit, compliance, and live integration boundaries
- Existing code, old DB shapes, old UI flows, old provider payloads, and old naming are evidence, not authority
- Domain-owned target contracts come before provider-shaped or legacy-shaped contracts
- Do not create temporary bridges, shims, adapters, or wrapper layers unless a concrete protected boundary requires one
- Every temporary bridge must have a deletion condition
- Favor one rebuilt vertical slice over broad partial rewrites
- Findings come first, then target architecture, then dependency-aware rebuild waves
- Ambiguity must be named as a decision, assumption, or blocker before execution

## Optional reviewer HTML

For large or review-heavy rebuild specs, or when the user asks for an easier-to-read artifact, use the global `spec-html-reader` skill to create `scratchpad/<spec-name>-reader.html`. Keep the Markdown spec authoritative, and make the HTML a standalone review surface with syntax-highlighted contracts, diagrams beside exact text, copy buttons, section search, and browser screenshots.

## Rebuild permission model

In this mode, the danger is preserving the wrong thing.

Allowed by default:

- delete legacy feature code when the replacement plan is clear
- rename concepts to match the new domain model
- replace internal route families and service boundaries
- update all internal call sites to the new model
- break internal DTOs and tool contracts
- redesign storage, queue, ingestion, retrieval, and runtime flows
- reject old conventions when they conflict with the target feature

Protected only when named:

- public API behavior
- production data
- billing, audit, security, and compliance guarantees
- third-party integration contracts
- deploy sequencing requirements
- user-visible behavior explicitly marked as valuable

## Required modes

Every substantial answer must declare exactly one active mode:

- `Excavate`
- `Critique`
- `Design`
- `Execute`
- `Closeout`

Mode meanings:

- `Excavate`: map what exists and why it likely exists
- `Critique`: classify what is essential, accidental, broken, or deletable
- `Design`: lock the target feature model and rebuild plan
- `Execute`: make scoped rebuild changes after explicit approval
- `Closeout`: prove what changed, what was removed, and what remains

If the user says `discuss`, `design`, `planning`, or `do not implement`, stay out of `Execute`.

## Required operating rules

- Never let the old feature negotiate the new architecture by default
- Never preserve parity unless the user names the parity surface
- Never call something a rebuild if it keeps the old architecture behind wrappers
- Never introduce a temporary bridge without a bridge justification
- Never hide unresolved ambiguity inside implementation waves
- Never mix confirmed facts with guesses
- Never say a surface is removed, rebuilt, or preserved without naming the exact ingress, file, contract, or dependency
- Never broaden beyond the declared feature boundary without saying why
- If the real feature boundary is larger than the user's initial list, name the expansion and ask only if it changes product or production risk
- If current concepts are overloaded, split them into a cleaner target taxonomy before execution
- If the user gives a locked target shape, treat it as the design anchor and validate old code against it
- If a bridge is unavoidable, define old surface, new surface, reason, deletion condition, owner, and expected lifespan

## Standard response format

Use this format for substantial responses.

```md
# Feature Rebuild Status
Mode: Excavate | Critique | Design | Execute | Closeout
Feature: <feature name>
Rebuild Stance: destructive-clean | hybrid | compatibility-preserving
Status: green | yellow | red
Decision: proceed | hold | blocked

## Summary
- <what is now true>
- <largest ambiguity or risk>
- <exact next recommendation>

## Product Intent
- user/job:
- current promise:
- desired promise:
- non-goals:

## Existing Feature Excavation
Surfaces:
- `<route/screen/job/tool/config>` -> `<file>`

Current workflow:
1. `<file/function>`
2. `<file/function>`
3. `<file/function>`

Current dependencies:
- db:
- queues:
- object storage:
- providers:
- runtime/tooling:

## Ingress Classification
Delete:
- `<surface>` -> reason

Rename/Rebuild:
- `<surface>` -> new target

Redesign:
- `<surface>` -> design decision needed

Temporary Bridge:
- `<surface>` -> bridge justification

Unknown:
- `<surface>` -> decision needed

## Keep / Change / Delete
Keep:
- <explicitly valuable behavior or contract>

Change:
- <behavior, model, naming, or flow to replace>

Delete:
- <legacy concept, file family, route, DTO, tool, or storage path>

## Protected Boundaries
Must preserve:
- <external contract, data, security, billing, audit, compliance, or live integration>

Allowed to break:
- <internal route, DTO, service, naming, storage, queue, tool, or UI convention>

Allowed to delete:
- <legacy surface>

## Target Feature Spec
- canonical domain taxonomy
- canonical naming
- user workflows
- system workflows
- states and lifecycle
- permissions and ownership
- data model
- API/routes/events/tools
- provider adapters
- persistence/search/storage
- queue/job shape
- observability and failure behavior
- deletion/reindex/recovery behavior

## Intentional Deltas
- current behavior:
- new behavior:
- reason:
- risk:
- proof needed:

## Bridge Justification
- old surface:
- new surface:
- reason:
- deletion condition:
- owner:
- expected lifespan:

## Truth Status
Confirmed:
- ...

Inferred:
- ...

Unknown:
- ...

## Rebuild Strategy

### Phase 1: <name>
- goal:
- depends on:

#### Wave 1.1: <name>
- goal:
- depends on:
- parallelizable: yes | no

Tasks:
- Task 1: <name> | depends on: ... | write scope: ...
- Task 2: <name> | depends on: ... | write scope: ...

First vertical slice:
- ingress:
- workflow:
- data:
- providers:
- proof:

## Closeout
Done:
- ...

Removed:
- ...

Not done:
- ...

Proof:
- `command/result`

Next:
- ...
```

Omit empty sections only when the user asks for a short answer. Keep `Ingress Classification`, `Keep / Change / Delete`, `Protected Boundaries`, `Truth Status`, and `Target Feature Spec` for planning work.

## Workflow

1. Lock the feature boundary.
2. Read any user-provided target shape first.
3. Excavate every declared ingress and dependency end to end.
4. Classify every ingress as `delete`, `rename/rebuild`, `redesign`, `temporary bridge`, or `unknown`.
5. Separate essential behavior from accidental legacy shape.
6. Name protected boundaries before proposing bridges.
7. Define the target domain taxonomy and canonical naming.
8. Define target workflows, states, ownership, contracts, storage, providers, queues, and failure behavior.
9. List intentional deltas from current behavior.
10. Resolve or explicitly park ambiguity before execution.
11. Create a dependency-aware rebuild strategy using phases, waves, and tasks.
12. Define the first rebuilt vertical slice.
13. Execute only after explicit approval.
14. Close out with proof, deleted surfaces, remaining legacy, and go / no-go.

## Ambiguity protocol

The goal is no ambiguity between the user and the agent.

For every material unknown, choose one:

- `Decision needed`: user/product choice required
- `Assumption`: agent can proceed if stated clearly
- `Blocked`: cannot proceed without missing evidence
- `Parked`: intentionally deferred and out of scope for the current wave

Before `Execute`, answer:

- What are we deleting?
- What are we preserving?
- What are we allowed to break?
- What must not break?
- What old names/concepts are banned?
- What bridges exist, and when do they die?
- What is the first vertical slice?
- What proof makes the slice done?

## Prompt templates

### Minimal invocation

```md
Use `feature-rebuild-planner`.

Mode: Design. Do not implement.

Feature:
- <feature name>

Current feature to strip out:
- <legacy feature/system>

Target shape:
- <target domain/object/workflow summary or file to read>

Surfaces to excavate:
- <routes/screens/jobs/tools/configs/runtime paths>

Constraints:
- <protected contracts/data/integrations>
- <allowed breaking changes>
```

### Full rebuild planning prompt

```md
Use `feature-rebuild-planner`.

Mode: discuss & design. Do not implement code yet.

We are doing a full strip-out rebuild of <legacy feature>, not a compatibility migration.
Breaking changes and large blast radius are acceptable.
Do not preserve legacy naming, DTOs, routes, tool contracts, storage flows, or conventions unless a concrete protected boundary requires it.

Task:
1. Map every current ingress path end to end.
2. Classify each ingress as delete, rename/rebuild, redesign, temporary bridge, or unknown.
3. Map current storage/search/ingestion/runtime dependencies.
4. Propose the clean target architecture.
5. Return findings first, then recommended architecture, then dependency-aware implementation waves.

Important:
- <locked domain rule>
- <ownership rule>
- <storage/provider rule>
- <tool/runtime rule>
```

## Decision rule

Ask the user only when one of these is genuinely unresolved:

- the feature boundary is ambiguous
- a protected public contract, production data, security, billing, audit, compliance, or live integration could break
- the target feature requires a product choice
- a temporary bridge is required but the deletion condition is unclear
- the user has not approved leaving `Design` for `Execute`

Otherwise:

- make a clear assumption
- say what old behavior or convention you are rejecting
- keep moving

## What good output feels like

The output should feel like:

- a feature excavation in `Excavate`
- a demolition list in `Critique`
- a clean target blueprint in `Design`
- a scoped rebuild in `Execute`
- a decisive proof report in `Closeout`

The user should not need to keep re-authorizing the same blast-radius and anti-legacy stance.
