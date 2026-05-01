---
name: design-collaboration
description: Collaborative UI/UX workflow for ambiguous or high-leverage design work. Use when the user wants brainstorming, multiple directions, ASCII mockups, self-critique, or an approval gate before coding.
disable-model-invocation: true
---

# Design Collaboration

Use this skill for net-new screens, redesigns, fuzzy UX, or when Hasan explicitly wants collaborative design exploration first.

Do not use this skill for tiny scoped polish/fixes inside an established pattern unless asked.

## Workflow

### 1. Discover

- Read the existing code/theme/tokens/components first.
- Identify user goal, constraints, risky edge cases, and required states.
- Ask only the questions that materially change IA, flow, or interaction.

### 2. Directions

- Present 3 materially different directions.
- Different means layout, hierarchy, or interaction model, not cosmetic variation.
- Give brief rationale and tradeoffs for each.
- Recommend one direction.
- No code yet.

### 3. Mockup

- Show ASCII mockups with realistic content.
- Include responsive notes where it matters.
- Include important states: loading, empty, error, hover, focus, success, destructive if relevant.
- Explain why the structure works.

### 4. Self-Critique

For each chosen mockup, call out:

- what feels weakest
- what could confuse users
- what may break on mobile
- what needs validation in implementation

### 5. Recommendation

- Recommend the strongest direction clearly.
- Say why it wins.
- Note what tradeoff you're accepting.
- Be decisive; don't leave Hasan to guess your view.

### 6. Approval Gate

- Stop after directions/mockups.
- Wait for approval before writing code.
- If feedback arrives, revise the design artifacts first, then implement.

## Output Shape

Keep it terse. Prefer:

1. goal + constraints
2. 3 directions
3. recommended direction
4. ASCII mockup
5. self-critique
6. recommendation
7. approval pause

## Quality Bar

- one clear primary action
- strong hierarchy
- consistent spacing rhythm
- obvious next step
- realistic states
- mobile viability
- accessible interactions
