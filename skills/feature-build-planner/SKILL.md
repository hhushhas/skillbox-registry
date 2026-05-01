---
name: feature-build-planner
description: "Plan new feature builds; use for greenfield slices, dependencies, and implementation waves."
disable-model-invocation: true
---

# Feature Build Planner

Use this skill when the user wants:

- a new feature built from scratch
- a feature added to an existing app with no real current implementation
- a new project feature where the architecture is still forming
- product intent translated into a buildable target spec
- project conventions discovered without treating absent code as a blocker
- a stable, low-reading-overhead planning and execution format

This skill is for feature inception. Existing project code is context and constraint, not legacy feature authority.

## Locked defaults

- Default unit of work: `feature surface`
- Default stance: `greenfield build`
- Default mode: `Frame` plus `Discover` unless the user explicitly asks to execute
- Do not implement until product intent, feature boundary, and first vertical slice are clear
- No legacy parity is required because no meaningful feature implementation exists
- Do not create migration bridges, compatibility shims, or old-to-new adapters unless integrating with a real protected boundary
- Existing app architecture, auth, permissions, routing, persistence, SDKs, design system, deploy flow, and observability are constraints to discover and respect
- Domain-owned feature contracts come before provider-shaped, UI-shaped, or storage-shaped contracts
- Favor one complete vertical slice over broad partial scaffolding
- Findings come first, then target spec, then dependency-aware build waves
- Ambiguity must be named as a decision, assumption, or blocker before execution

## Optional reviewer HTML

For large or review-heavy feature specs, or when the user asks for an easier-to-read artifact, use the global `spec-html-reader` skill to create `scratchpad/<spec-name>-reader.html`. Keep the Markdown spec authoritative, and make the HTML a standalone review surface with syntax-highlighted contracts, diagrams beside exact text, copy buttons, section search, and browser screenshots.

## Build permission model

In this mode, the danger is inventing false legacy constraints or shipping a half-feature.

Allowed by default:

- introduce new domain concepts and canonical names
- create new routes, screens, services, jobs, schemas, SDK methods, and storage paths
- choose the simplest architecture that fits the first real workflow
- defer speculative abstractions until a second concrete use appears
- leave explicitly parked future workflows out of the first slice
- use existing project conventions where they reduce integration risk

Protected only when relevant:

- public API behavior
- production data
- auth, tenancy, permissions, billing, audit, security, and compliance guarantees
- third-party integration contracts
- deploy sequencing requirements
- user-visible behavior in adjacent features
- established design-system and navigation patterns

## Required modes

Every substantial answer must declare exactly one active mode:

- `Frame`
- `Discover`
- `Design`
- `Execute`
- `Closeout`

Mode meanings:

- `Frame`: lock product intent, feature boundary, audience, non-goals, and success proof
- `Discover`: map surrounding project conventions, integration points, dependencies, and constraints
- `Design`: define the target feature spec and dependency-aware build plan
- `Execute`: make scoped build changes after the feature boundary and first vertical slice are clear
- `Closeout`: prove what was built, what remains parked, and whether the feature is ready

If the user says `discuss`, `design`, `planning`, `spec`, or `do not implement`, stay out of `Execute`.

## Required operating rules

- Never fabricate an existing feature just to follow a rebuild workflow
- Never preserve parity with a feature that does not exist
- Never use surrounding project conventions as an excuse to avoid naming the target feature model
- Never broaden beyond the declared feature boundary without saying why
- Never hide product ambiguity inside implementation waves
- Never mix confirmed facts with guesses
- Never add a new dependency without checking maintenance, recency, adoption, and obvious risk flags
- Never call the first slice complete without naming the user workflow, data path, failure behavior, and proof
- If the project has an established design system, SDK boundary, API contract pattern, or Effect/service pattern, fit the new feature into it
- If the project lacks a convention, choose the smallest durable pattern and state the assumption
- If the user provides a locked target shape, treat it as the design anchor
- If future scope is tempting but not needed for the first slice, park it explicitly

## Standard response format

Use this format for substantial responses.

```md
# Feature Build Status
Mode: Frame | Discover | Design | Execute | Closeout
Feature: <feature name>
Build Stance: greenfield | existing-project-new-feature | prototype | production
Status: green | yellow | red
Decision: proceed | hold | blocked

## Summary
- <what is now true>
- <largest ambiguity or risk>
- <exact next recommendation>

## Product Intent
- user/job:
- current gap:
- desired promise:
- primary workflow:
- non-goals:

## Feature Boundary
In scope:
- <workflow/screen/route/job/tool/config>

Out of scope:
- <parked future surface>

Success proof:
- <command, browser flow, API call, test, or live behavior>

## Project Discovery
Existing conventions:
- auth/session:
- permissions/tenancy:
- routing/API:
- schemas/contracts:
- persistence:
- SDK/client:
- UI/design:
- jobs/queues:
- observability:
- tests:
- deploy/runtime:

Relevant files:
- `<surface>` -> `<file>`

## Integration Classification
Use existing:
- `<pattern/boundary>` -> reason

Create new:
- `<surface>` -> target owner

Adapt:
- `<boundary>` -> why adaptation is needed

Park:
- `<future surface>` -> why not in first slice

Unknown:
- `<question>` -> decision needed

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
- UI states and empty states
- observability and failure behavior
- deletion/recovery behavior

## First Vertical Slice
- user outcome:
- ingress:
- workflow:
- data:
- UI/API:
- providers:
- failure behavior:
- proof:

## Truth Status
Confirmed:
- ...

Inferred:
- ...

Unknown:
- ...

## Build Strategy

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

## Closeout
Done:
- ...

Parked:
- ...

Not done:
- ...

Proof:
- `command/result`

Next:
- ...
```

Omit empty sections only when the user asks for a short answer. Keep `Product Intent`, `Feature Boundary`, `Project Discovery`, `Integration Classification`, `Target Feature Spec`, `First Vertical Slice`, and `Truth Status` for planning work.

## Workflow

1. Lock the product intent, primary user, and success proof.
2. Define the feature boundary and explicit non-goals.
3. Read any user-provided target shape first.
4. Discover surrounding project conventions and protected boundaries.
5. Classify each integration point as `use existing`, `create new`, `adapt`, `park`, or `unknown`.
6. Define the target domain taxonomy and canonical naming.
7. Define target workflows, states, ownership, contracts, storage, providers, jobs, UI states, and failure behavior.
8. Define the first complete vertical slice.
9. Resolve or explicitly park ambiguity before execution.
10. Create a dependency-aware build strategy using phases, waves, and tasks.
11. Execute only when the feature boundary and first slice are clear, or when the user explicitly asks to move fast with named assumptions.
12. Close out with proof, parked scope, remaining work, and ready / not-ready status.

## Ambiguity protocol

The goal is no ambiguity between the user and the agent.

For every material unknown, choose one:

- `Decision needed`: user/product choice required
- `Assumption`: agent can proceed if stated clearly
- `Blocked`: cannot proceed without missing evidence
- `Parked`: intentionally deferred and out of scope for the current wave

Before `Execute`, answer:

- What user outcome are we building?
- What is the first vertical slice?
- What project boundaries must it integrate with?
- What are we creating new?
- What existing conventions are we reusing?
- What future scope is parked?
- What proof makes the slice done?

## Prompt templates

### Minimal invocation

```md
Use `feature-build-planner`.

Mode: Design. Do not implement.

Feature:
- <feature name>

Target outcome:
- <user/job/workflow summary>

Project context:
- <new project or existing project paths>

Constraints:
- <auth/data/integration/design/deploy constraints>
- <non-goals>
```

### Full greenfield planning prompt

```md
Use `feature-build-planner`.

Mode: discuss & design. Do not implement code yet.

We are building <feature> from scratch. There is no existing feature implementation to preserve or rebuild.

Task:
1. Lock product intent, users, success proof, and non-goals.
2. Discover the surrounding project conventions and protected boundaries.
3. Classify integrations as use existing, create new, adapt, park, or unknown.
4. Propose the target feature spec.
5. Define the first complete vertical slice.
6. Return findings first, then recommended architecture, then dependency-aware implementation waves.

Important:
- <domain rule>
- <ownership rule>
- <storage/provider rule>
- <UI/runtime rule>
```

## Decision rule

Ask the user only when one of these is genuinely unresolved:

- the product intent or primary user workflow is ambiguous
- the feature boundary is ambiguous
- a protected public contract, production data, auth, billing, audit, security, compliance, or live integration could break
- the target feature requires a product choice
- a new dependency is needed and the risk/fit is not clearly acceptable
- the user has not approved leaving `Design` for `Execute` and the work is broad

Otherwise:

- make a clear assumption
- say which project convention you are reusing
- park future scope explicitly
- keep moving

## What good output feels like

The output should feel like:

- a product-framing checkpoint in `Frame`
- an integration map in `Discover`
- a clean target blueprint in `Design`
- a scoped first slice in `Execute`
- a decisive proof report in `Closeout`

The user should not need to keep reminding the agent that this is new-feature work, not a rebuild or migration.
