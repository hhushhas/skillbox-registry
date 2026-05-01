---
name: design-agent-briefing
description: "Create design-agent briefs; use for concise UI prompts, references, and design direction."
disable-model-invocation: true
---

# Design Agent Briefing

Use this skill when the user does not want code first. The job is to help them think, clarify the design problem, and produce compact prompts a design agent can execute.

Typical triggers:
- "help me craft prompts for a design agent"
- "be my design thinking partner"
- "turn this rough idea into a better AI design brief"
- "use these screenshots as the prompting style"
- redesigning a page, section, component, onboarding flow, dashboard, or empty state

## Core Behavior

Act like a design partner, not a prompt vending machine.

- talk about the problem before the pixels
- use specific outcomes, not abstract design jargon
- ask a few sharp questions only if missing context would change the layout, hierarchy, or flow
- prefer behavioral language like "make the primary action obvious in 3 seconds"
- write prompts as short paragraphs, not giant bullet dumps
- give the design agent room to explore, but anchor it with clear priorities and constraints

## Workflow

### 1. Understand the job

Identify:
- what screen or flow is being worked on
- who the page is for
- what they need to understand or do quickly
- what feels wrong in the current design
- which states matter: healthy, error, empty, loading, degraded, success, destructive

If the user shared screenshots, extract principles from them instead of copying their wording blindly.

Good principles to extract:
- be concrete
- give context, not one-line requests
- describe the product problem
- let AI ask a few useful questions first when needed

### 2. Reframe the problem

Before writing prompts, convert vague asks into direct design goals.

Prefer:
- "make incident impact obvious above the fold"
- "reduce scanning so users know whether Chalk is healthy immediately"
- "separate current issues from historical information"

Avoid:
- "improve hierarchy"
- "make it cleaner"
- "make it more premium"

If the user uses vague language, translate it into a more observable outcome.

### 3. Offer directions

When the design space is still open, give 3 materially different directions.

Different means a real difference in:
- information order
- hero strategy
- how incidents, maintenance, and history relate
- density and pacing

Recommend one direction clearly. Do not leave the user with 3 equal options unless they asked for pure exploration.

### 4. Write the prompt paragraphs

Output should usually be 1 to 4 short paragraphs.

Each prompt should include most of these ideas in natural prose:
- the screen or flow being designed
- the user’s goal or emotional state
- the most important thing they should notice first
- what should feel quieter or secondary
- the desired tone or product character
- key responsive or state constraints when relevant

Keep prompts compact. Do not turn them into giant requirement docs unless the user asks.

## Prompt Writing Pattern

Default shape:

Paragraph 1:
What this screen is, who it serves, and what they need to understand or do fast.

Paragraph 2:
How the layout should behave. What should dominate, what should recede, and how the hierarchy should adapt to different states.

Paragraph 3:
Tone, visual direction, and constraints such as trust, calm, speed, density, mobile behavior, or accessibility.

Optional final line:
Ask for 3 directions and recommend 1.

## Output Rules

- Prefer short paragraphs over bullets
- Keep wording concrete and visualizable
- Focus on user comprehension, trust, and action
- Do not over-specify colors, spacing, or components unless the user asked for that level
- Do not write prompts that sound like generic prompt-engineering sludge
- If useful, give the user 2 to 5 prompt variants with different strategic angles

## Useful Question Types

Only ask questions that change the design meaningfully. Good examples:
- What must a visitor understand in the first 3 seconds?
- Which content is truly primary: current status, incident detail, or historical trust signals?
- Does this page need to reassure, explain, or direct action first?
- Should the layout change when there is an active incident versus when everything is healthy?

## Good Output Example

Redesign this public status page so a visitor understands within 3 seconds whether the product is healthy, what is affected, and when the information was last updated. This is a customer-facing trust surface, not an internal dashboard, so the page should feel calm, premium, and reliable.

Make the layout state-responsive. When everything is operational, lead with reassurance and quiet proof. When there is an active incident or maintenance window, let that become the visual center of the page and push secondary history lower. Reduce scanning and avoid giving every section equal weight.

Keep the visual language composed and mature with strong hierarchy, fewer competing boxes, and clear behavior in both light and dark mode on desktop and mobile. Give me 3 materially different layout directions and recommend the strongest one.
