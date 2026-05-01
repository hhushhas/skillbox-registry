---
name: spec-html-reader
description: "Render specs as HTML; use for reviewable architecture, plans, diagrams, and contracts."
---

# Spec HTML Reader

Use this skill to turn a review-heavy spec into a self-contained HTML artifact that is easier to scan than raw Markdown while preserving exact technical contracts.

## Output

- Write a single standalone HTML file to `scratchpad/<spec-name>-reader.html`.
- Put browser screenshots under `scratchpad/<spec-name>-screenshots/`.
- Do not require a framework, build step, CDN, or server.
- Keep the source spec authoritative; the HTML is a review artifact, not a replacement for the spec.
- Reference example: `references/example-knowledgebase-reader.html`. Load it only when useful for layout, styling, syntax-highlighting, copy-button, search/filter, or diagram patterns.

## When To Use

Use when the user asks for:

- an HTML spec reader
- a readable version of a spec
- a reviewer-friendly architecture/spec artifact
- diagrams from a refactor/feature/rebuild contract
- an easier-to-scan version of a long Markdown plan

Contract skills may call this optional artifact lane when a spec is large, review-heavy, or explicitly intended for user approval before execution.

## Reader Requirements

- Dark mode only is fine.
- Use a polished Linear-style UI with a top navbar, not a sidebar.
- Preserve precise contracts and decisions.
- Reorganize content into readable sections rather than mirroring raw Markdown order.
- Add section search/filter.
- Add copy buttons for code blocks.
- Syntax-highlight TypeScript, JSON, HTTP/API, shell, structured text, SDK method shapes, status lists, and config snippets.
- Show diagrams alongside exact contracts, not instead of them.
- Prefer compact tables, step rows, flow maps, and code panels over long bullet lists.
- Keep typography consistent.
- Do not put cards inside cards.
- Avoid decorative clutter.

## Visuals

Use visual summaries where they make the spec easier to review:

- target domain shape
- actor/layer responsibility map
- request/runtime/retrieval paths
- storage boundaries
- dependency map
- API/SDK surface map
- execution waves
- cutover/verification gates

Diagrams must be explanatory, not decorative. Give diagrams enough canvas space. Avoid cramped arrows, unexplained floating badges, text overflowing nodes, and arrows crossing through labels.

## Contracts

Keep exact contract blocks visible with syntax highlighting:

- TypeScript object/type shapes
- JSON request/response examples
- API route tables or HTTP examples
- SDK method shapes
- lifecycle/status enums
- config snippets
- object storage keys
- queue/job payloads
- tool request/response contracts

When the spec includes TypeScript enums, prefer showing readonly `as const` arrays plus inferred union types if that is the project convention.

## Logos And Assets

- Use real logos selectively when they improve scanability.
- Prefer confirmed source assets such as SVGL when available.
- Do not invent fake brand marks for providers whose logos are not available.
- Neutral text badges are better than inaccurate logos.

## Verification

Render the HTML in a browser before closeout.

Verify:

- page is not blank
- top nav works
- search/filter works
- copy buttons exist
- syntax-highlighted blocks are present
- diagrams are legible
- text does not overflow buttons, cards, diagram nodes, or tables
- arrows do not obscure labels
- desktop and narrow/mobile screenshots render acceptably

Report screenshot paths and any known limitations.
