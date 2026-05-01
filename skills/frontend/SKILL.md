---
name: frontend
description: "Build and polish frontend UI; use for layouts, components, accessibility, and visual QA."
disable-model-invocation: true
---

# Frontend

Use this as the default entrypoint for frontend work.

Primary goal:
- make products clearer, sharper, more usable, more distinctive

## Scope

- UI and design first
- implementation quality matters as much as aesthetics
- preserve existing visual language and design system unless Hasan asks for redesign
- minimal, surgical edits by default
- prefer existing components before custom markup

## Use for

- frontend screens and flows
- React components and pages
- landing pages and marketing surfaces
- dashboards and app UI
- UI polish and visual cleanup
- layout, hierarchy, copy density, and states
- accessibility and interaction review
- design-system-aware implementation

## Routing

- ambiguous or high-leverage UX exploration:
  `/Users/macmini/.agents/skills/design-collaboration`
- accessibility / UX review / interface rule checks:
  `/Users/macmini/.agents/skills/web-design-guidelines`
- shadcn/ui repos and component work:
  `/Users/macmini/.agents/skills/shadcn`
- React, Next.js, React Native, Expo:
  `/Users/macmini/.agents/skills/react`
- TanStack Start apps:
  `/Users/macmini/.agents/skills/tanstack-start-best-practices`
- distinctive aesthetic direction / bold frontend execution:
  `/Users/macmini/.agents/skills-archive/frontend/frontend-design`

## Mandatory stack note

If the project uses React, Next.js, React Native, or Expo:
- open the `react` skill
- treat it as required companion guidance

If the project uses TanStack Start:
- open `tanstack-start-best-practices` too

If the repo uses shadcn/ui:
- open `shadcn`

## Default workflow

1. Read existing code, theme, tokens, components, and layout patterns first.
2. Identify:
   - user goal
   - primary action
   - critical edge cases
   - required states
   - whether this is polish, redesign, or net-new UI
3. Route only to the narrow companion skills needed.
4. Implement production code, not mock-only artifacts, unless Hasan asks for exploration first.

## Design fundamentals

- prioritize user goal, main action, and failure modes first
- hierarchy through size, weight, contrast, spacing
- progressive disclosure over dumping full complexity
- orient users in multi-step flows: where they are, what is next, how much remains
- consistency reduces cognitive load
- strongest contrast belongs to the most important or riskiest action
- accessibility is baseline quality, not optional polish
- related things stay together; dangerous actions stay apart
- alignment and grids create trust and scanability
- sequence screens around how users think and act
- remove before adding
- avoid generic AI UI sameness
- if something feels off, check in this order:
  - hierarchy
  - spacing
  - alignment
  - contrast
  - copy
  - states

## Aesthetic direction

Commit to a clear visual point of view:
- brutally minimal
- editorial
- refined
- playful
- industrial
- organic
- retro-futurist
- brutalist
- luxury
- or another intentional direction

Rule:
- intentionality over default prettiness
- no generic purple-glow AI look unless the brand clearly wants it
- no interchangeable UI

## Frontend quality rules

- semantic HTML first
- `button` for actions, link for navigation
- icon-only controls need labels
- visible focus states always
- forms need labels, sensible types, inline errors, keyboard reachability
- cover loading, empty, error, disabled, hover, focus, success states
- destructive actions need confirmation or undo
- images need dimensions and correct alt behavior
- mobile matters: touch targets, safe areas, no desktop-only assumptions
- avoid `transition: all`

## Code rules

- types inferred, not manually defined
- keep files around ~300 LOC when the change naturally warrants splitting
- preserve existing functionality unless asked otherwise
- follow existing patterns; do not invent new local conventions casually
- use design tokens over raw values when available
- avoid arbitrary values when system tokens already solve it

## React defaults

When React applies, keep these active:
- `useEffect` only for external systems
- derive UI state in render when possible
- user-driven logic in handlers, not effect chains
- start async work early
- parallelize independent fetches
- prefer server-first patterns when architecture supports them
- use Suspense and transitions when they improve responsiveness