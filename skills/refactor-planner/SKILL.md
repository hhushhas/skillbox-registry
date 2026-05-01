---
name: refactor-planner
description: "Plan refactors; use for migration maps, dependency waves, and low-overhead contracts."
disable-model-invocation: true
---

# Refactor Planner

Use this skill for large refactors and migrations where the user wants:

- one stable answer shape every time
- low reading overhead
- route-family-first mapping
- dependency-aware waves
- explicit separation of confirmed facts vs guesses
- tight coordination between mapping, design, execution, and closeout

This skill is especially useful for API-server migrations such as:

- Express -> Hono
- controller style -> Effect services
- untyped handlers -> typed contracts
- mixed legacy runtime -> Effect-first runtime

## Locked defaults

- Default unit of work: `route family`
- Default answer density: `balanced`
- Default mapping direction: `ingress -> security -> handler -> domain -> services -> providers -> leaf edges`
- Default stance: do not broaden scope beyond the active slice
- If the user provides only `domain + target change + entry points`, default to a `Map` plus `Design` pass, not implementation
- Stay in `Map` and `Design` until the user gives explicit implementation approval, especially for broad refactors where architecture, naming, flows, slices, and final code shape are still being decided
- Bias toward locking the final target architecture before suggesting execution
- Define domain-owned contracts first, then validate them against real leaf providers; do not let provider payloads define the abstraction by accident
- No temporary shims, no compatibility adapters, and no legacy bridge layers unless the user explicitly approves them
- Bias toward one cohesive end-state spec rather than fragmented chronological journaling
- Provider lanes start as read-only contract-validation audits before any implementation
- Before implementation begins, define the execution strategy explicitly instead of making the user restate it
- Execution strategy should be dependency-tracked at `phase -> wave -> task` level to prevent conflicts, improve coordination, and make parallel delegation straightforward
- Default parallel implementation worker model: `gpt-5.3-codex` with `high` reasoning, unless the user explicitly overrides it
- When parallel workers are launched, be patient: prefer completed artifacts or explicit blockers over rushed “quick summary” check-ins
- In that minimal-invocation case, default outputs are:
  - call graph per entry point
  - spine map per entry point
  - shared logic vs divergent logic
  - hidden coupling and cross-cutting concerns
  - candidate seams and boundaries
  - proposed target architecture
  - dependency-tracked execution strategy
  - first implementation wave only

## Optional reviewer HTML

For large or review-heavy refactor specs, or when the user asks for an easier-to-read artifact, use the global `spec-html-reader` skill to create `scratchpad/<spec-name>-reader.html`. Keep the Markdown spec authoritative, and make the HTML a standalone review surface with syntax-highlighted contracts, diagrams beside exact text, copy buttons, section search, and browser screenshots.

## Core terms

- `Phase`
  Larger execution grouping that contains multiple waves

- `Spine map`
  End-to-end path for the active slice:
  ingress -> auth/security -> handler/controller -> domain service -> downstream services/providers -> shared utils/types -> persistence/external APIs

- `Tracer bullet`
  One narrow end-to-end implementation slice used to prove the target architecture before broader rollout

- `Wave`
  A dependency-aware execution batch with a clear write scope and clear exit gate

- `Task`
  Smallest execution unit inside a wave, used for sequencing and delegation

- `Slice`
  The exact route family or capability currently being worked on

## Required operating rules

- Never start implementation before building the spine map for the active slice
- Never leave `Map` or `Design` mode for broad refactors until the user explicitly authorizes implementation
- Never say a module is migrated without naming exact ingress paths and files
- Never mix confirmed facts with guesses
- Never silently absorb adjacent slices into the current wave
- Never rewrite the whole migration plan when the user only asked for the next wave
- If architecture is unclear, stop in `Design` mode instead of forcing code
- If domain concepts are overloaded or muddled, split them into a cleaner taxonomy before proposing execution waves
- Lock canonical naming, workflow boundaries, ownership boundaries, gateway/repository surfaces, provider-lane scope, and schema implications before proposing implementation
- Provider APIs are validation targets, not design anchors; define domain abstractions first and then test them against real provider shapes
- Do not introduce temporary adapters, legacy compatibility bridges, or “just for now” shims unless the user explicitly approves that tradeoff
- Do not let naming drift into UI-shaped names, provider-shaped abstractions, or vague catch-all `*Service` labels
- Prefer one cohesive end-state spec over chronological diary-style reporting when the user is still shaping the design
- When a provider lane is in scope, start with a read-only contract-validation audit before discussing implementation in that lane
- Before `Execute`, lock an explicit dependency-tracked execution strategy using phases, waves, and tasks
- Every phase, wave, and task should declare dependencies clearly enough that parallel workers can be delegated without conflicting write scopes
- Do not rush subagents for premature completion or interim summaries when the real need is the finished artifact, diff, spec, or blocker report

## Required mode declaration

Every substantial answer must declare exactly one active mode:

- `Map`
- `Design`
- `Execute`
- `Closeout`

If the user does not specify a mode, infer the best one and say so explicitly.

## Standard response format

Use this format for substantial responses.

```md
# Refactor Status
Mode: Map | Design | Execute | Closeout
Scope: <one sentence>
Slice: <active route family>
Status: green | yellow | red
Decision: proceed | hold | blocked

## Summary
- <what is now true>
- <what changed since last pass>
- <biggest risk>
- <exact next recommendation>

## End-State Spec
- canonical domain taxonomy
- canonical naming
- target workflow families
- request / trigger / source enums
- ownership boundaries
- gateway / repository surfaces
- schema implications
- target architecture

## Spine Map
Ingress:
- `route/pattern` -> `file`

Flow:
1. `file/function`
2. `file/function`
3. `file/function`

Downstream:
- `service/provider`
- `service/provider`

Shared:
- `utils/types/contracts`

Leaf edges:
- `db/external api/queue/cache`

## Truth Status
Confirmed:
- ...

Inferred:
- ...

Unknown:
- ...

## Active Wave
Wave: <name>
Goal: <one sentence>
Depends on:
- <phase / wave / task dependency>

Write scope:
- `path`
- `path`

Out of scope:
- `path or concern`

Exit gate:
- `command or proof`
- `command or proof`

## Closeout
Done:
- ...

Not done:
- ...

Proof:
- `command/result`
- `command/result`

Next:
- ...
```

When the user is still shaping design, treat `End-State Spec` as mandatory and `Active Wave` as provisional.

Before `Execute`, add an execution-strategy section when the user is locking implementation:

```md
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
- default parallel worker model: `gpt-5.3-codex`
- default reasoning: `high`
- default behavior: wait for the worker to finish the assigned artifact unless it is blocked or the user explicitly asks for an interim update
```

If the user asks for code-shape guidance, add an optional companion artifact alongside the main markdown file covering:

- readability rules
- Effect conventions
- tagged errors
- retries and concurrency rules
- facades and adapter/gateway patterns
- good and bad examples

## Formatting rules

- Keep sections short
- No paragraph walls
- No nested bullets
- Prefer paths, routes, and function names over prose
- Use numbered flow steps for the request path
- Keep each bullet to one idea
- If the answer gets too long, split it into:
  - `Now`
  - `Later`
  - `Appendix`

## Workflow

1. Lock the active slice
2. Build the spine map from ingress to leaf edges
3. Separate `Confirmed`, `Inferred`, and `Unknown`
4. Clean up the domain taxonomy if concepts are overloaded
5. Define domain-owned contracts and validate them against real leaf providers
6. Audit provider lanes as read-only contract-validation passes before implementation
7. Lock target architecture, canonical naming, workflow boundaries, ownership boundaries, gateway/repository surfaces, provider-lane scope, and schema implications
8. Define an explicit dependency-tracked execution strategy using phases, waves, and tasks
9. Define the first implementation wave only after those are agreed
10. Create the optional code-shape companion artifact when the user asks for code conventions or implementation style guidance
11. Execute only when the user explicitly authorizes implementation
12. Be patient with delegated workers and wait for finished artifacts or explicit blockers instead of asking for rushed summaries
13. Keep write scope explicit
14. Close out with proof and a go / no-go statement

## Route-family-first mapping method

Start from the ingress and trace only the active slice:

1. route or handler entry
2. auth/security extraction
3. request decode or boundary handler
4. domain service or orchestrator
5. lower services
6. provider edges
7. persistence, queues, cache, or external APIs

If cross-slice dependencies appear:

- list them in `Truth Status` or `Active Wave`
- do not absorb them into the current wave unless the user explicitly broadens scope

## Design-mode expectations

When the user is still shaping architecture, naming, slices, flows, or end-state structure, stay in `Design`.

In that state, the agent should:

- lock the target architecture before talking about execution
- separate overloaded domain concepts into a cleaner taxonomy when needed
- lock ubiquitous naming before proposing waves
- define canonical names for workflow families, request types, trigger/source enums, gateways, repositories, providers, and key service/function boundaries
- define domain-owned contracts first
- validate those contracts against real provider leaves
- start provider lanes as read-only contract-validation audits
- lock exact workflow boundaries and ownership boundaries
- lock gateway/repository surfaces, provider-lane scope, and schema implications
- define the execution strategy explicitly before implementation
- structure execution as dependency-tracked phases, waves, and tasks
- make dependencies explicit enough for safe parallel delegation
- prefer completed worker artifacts, diffs, specs, or blocker reports over quick interim summaries
- end with the first implementation wave only after the above are agreed

Do not treat “the code seems straightforward” as permission to start implementing.

## Prompt templates

Use the shortest prompt that still locks the task correctly.

### Minimal invocation

This is the default contract when the user invokes the skill with only the essentials.

If the user says something like:

- use `refactor-planner`
- domain is `<domain>`
- target change is `<from> -> <to>`
- entry points are `<list>`

then infer all of this automatically unless the user overrides it:

- mode: `Map` plus `Design`
- no implementation yet
- stay in `Map` plus `Design` until explicit implementation approval
- output goes to a markdown file when the user asks for a file or durable artifact
- mapping is route-family-first
- keep `Confirmed`, `Inferred`, and `Unknown` separate
- include call graph and spine map for each entry point
- include domain taxonomy cleanup if the current concepts are overloaded
- include domain-owned contracts and validation against leaf providers
- start provider lanes as read-only contract-validation audits
- include a dependency-tracked execution strategy with phases, waves, and tasks
- default parallel worker model to `gpt-5.3-codex` with `high` reasoning unless the user overrides it
- prefer waiting for completed worker output unless the worker is blocked or the user asks for an interim status
- finish with one cohesive end-state spec covering naming, boundaries, surfaces, schema implications, target architecture, and the first implementation wave only

The user should not need to restate the entire contract every time.

### Short sharp template

Use this when the user wants a focused mapping or design pass.

```md
This is a refactor pass, not an implementation pass.

Target:
- <from>
- <to>

Active slice:
- <route family / module / capability>

What I need:
- map this slice from entry point to leaf dependencies
- produce call graph and spine map
- surface hidden coupling, cross-cutting concerns, and blast radius
- keep confirmed / inferred / unknown separate
- lock the target architecture before execution
- clean up overloaded concepts into a deliberate taxonomy
- lock canonical naming before proposing waves
- define domain-owned contracts before provider-shaped abstractions
- start provider lanes as read-only contract-validation audits
- define the dependency-tracked execution strategy
- define the first implementation wave only
- do not broaden scope
```

### Reusable full template

Use this when the user is coordinating a larger migration across multiple entry points.

```md
We are doing a large refactor / migration.

This pass is:
- Map | Design | Execute | Closeout

Target change:
- from: <current architecture>
- to: <target architecture>

Domain:
- <domain or capability>

Entry points:
- <entry point 1>
- <entry point 2>
- <entry point 3>

Why this pass matters:
- <why these paths belong together>

What I want:
- call graphs for each entry point
- spine maps for each entry point
- shared logic vs divergent logic
- hidden coupling and cross-cutting concerns
- candidate seams and boundaries
- cleaned-up domain taxonomy when concepts are overloaded
- canonical naming for workflow families, request types, trigger/source enums, gateways, repositories, providers, and key service/function boundaries
- domain-owned contracts validated against real leaf providers
- provider lanes treated as read-only contract-validation audits first
- recommended target layering and service ownership
- exact workflow boundaries, gateway/repository surfaces, provider-lane scope, and schema implications
- dependency-tracked phases, waves, and tasks for execution
- default parallel worker model and reasoning level
- the first dependency-aware implementation wave only after the design is locked

Constraints:
- <type safety / framework / runtime / compatibility rules>
- <preserve parity or allow intentional delta>
- no temporary shims or compatibility adapters unless explicitly approved
- do not broaden scope beyond these entry points
- keep confirmed / inferred / unknown separate

Output:
- write to a markdown file
- keep one consistent format throughout
- name exact files, routes, handlers, services, and leaf dependencies
```

### Call-surface mapping template

Use this when several entry points feed one shared behavior and the user wants centralization.

```md
This is a mapping-and-design pass only.
Do not implement yet.

I want you to map the following entry points:
- <entry point 1>
- <entry point 2>
- <entry point 3>

These paths all participate in:
- <shared behavior, such as call creation, intake, billing, or sync>

The goal is to:
- identify the real shared logic
- identify divergent handling
- show what should be centralized
- prepare for a full migration to <target architecture>
- lock the architecture before any implementation

For each entry point, give me:
- call graph
- spine map
- downstream services and leaf dependencies
- hidden coupling
- cross-cutting concerns
- seams
- truth status: confirmed / inferred / unknown

After mapping all entry points, give me:
- shared surface to centralize
- divergences that must be preserved or removed
- cleaned-up domain taxonomy if current concepts are overloaded
- canonical naming for workflow families, request types, trigger/source enums, gateways, repositories, providers, and key service/function boundaries
- domain-owned contracts validated against real leaf providers
- provider lanes as read-only contract-validation audits first
- proposed target architecture
- exact boundaries, gateway/repository surfaces, provider-lane scope, and schema implications
- dependency-tracked phases, waves, and tasks for execution
- first implementation wave only
```

### Minimal user prompt

This should be enough for future runs:

```md
Use `refactor-planner`.

Domain:
- <domain>

Target change:
- from: <current shape>
- to: <target architecture>

Entry points:
- <entry point 1>
- <entry point 2>
- <entry point 3>
```

## Decision rule

Ask the user only when one of these is genuinely unresolved:

- the active slice is ambiguous
- a public contract or API behavior would change
- the migration requires choosing between materially different architectures
- the requested wave would cause broad scope expansion
- the user has not yet explicitly approved leaving `Design` for implementation

Otherwise:

- choose a reasonable default
- say what you assumed
- keep moving

## What good output feels like

The output should feel like:

- a compact codebase x-ray in `Map`
- a precise boundary spec in `Design`
- a tight scoped change report in `Execute`
- a decisive go / no-go gate in `Closeout`

The user should never need to mentally normalize a brand new answer shape.
