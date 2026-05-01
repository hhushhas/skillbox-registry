---
name: better-auth
description: "Implement Better Auth; use for auth flows, organizations, RBAC, MFA, and security."
disable-model-invocation: true
---

# Better Auth

Use this as the single entrypoint for Better Auth work.

## Use for

- adding auth to an app
- Better Auth setup and configuration
- email/password flows
- password reset and verification
- orgs, teams, roles, RBAC
- 2FA / MFA
- Better Auth security guidance

## Routing

- general setup and config:
  `/Users/macmini/.agents/skills-archive/better-auth/better-auth-best-practices`
- scaffold auth into an app:
  `/Users/macmini/.agents/skills-archive/better-auth/create-auth-skill`
- email/password specifics:
  `/Users/macmini/.agents/skills-archive/better-auth/email-and-password-best-practices`
- organizations / RBAC:
  `/Users/macmini/.agents/skills-archive/better-auth/organization-best-practices`
- 2FA / MFA:
  `/Users/macmini/.agents/skills-archive/better-auth/two-factor-authentication-best-practices`
- security hardening:
  `/Users/macmini/.agents/skills-archive/better-auth/better-auth-security-best-practices`

## Default behavior

1. Identify whether the task is:
   - greenfield auth setup
   - existing app auth integration
   - auth feature extension
   - security hardening
2. Open only the matching archived leaf skill.
3. Prefer official Better Auth docs for current API details.

## Rule

Keep Better Auth as one visible skill. Treat archived leaves as implementation detail.
