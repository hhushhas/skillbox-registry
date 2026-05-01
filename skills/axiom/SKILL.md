---
name: axiom
description: "Investigate Axiom observability; use for logs, dashboards, incidents, and query cost."
disable-model-invocation: true
---

# Axiom

Use this as the single entrypoint for Axiom-related work.

## Use for

- incident response and production debugging
- log and metrics investigation
- dashboard design and rollout
- ingest waste analysis
- query/cost optimization

## Routing

- SRE / incidents / root cause:
  `/Users/macmini/.agents/skills-archive/axiom/axiom-sre`
- dashboards / chart design / APL panel design:
  `/Users/macmini/.agents/skills-archive/axiom/building-dashboards`
- spend reduction / waste audits / monitor design:
  `/Users/macmini/.agents/skills-archive/axiom/controlling-costs`

## Default behavior

1. Start with the narrowest real objective:
   - debug incident
   - build dashboard
   - reduce cost
2. Open only the archived leaf skill that matches.
3. Reuse its scripts/references rather than duplicating process.

## Rule

Do not expose the archived leaf skills directly as first-class choices again unless explicitly restoring them.
