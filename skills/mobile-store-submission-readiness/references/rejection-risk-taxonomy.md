# Rejection-Risk Taxonomy

Use this to prioritize findings.

## P0 Blockers

Likely rejection, cannot submit, or reviewer cannot complete review:

- app crashes, hangs, blank screens, broken first-run flow, broken login
- missing reviewer/demo access, blocked 2FA, invite-only app with no review path
- account creation without in-app deletion
- required Apple login-services gap on iOS
- missing privacy policy or severe App Privacy/Data Safety mismatch
- undeclared or unjustified sensitive permissions
- UGC without reporting/moderation where required
- AI-generated content risk without required reporting/controls
- expired/invalid certificates, provisioning, app signing, API keys, or target SDK
- metadata/screenshots materially misrepresent the app

## P1 High Risk

Likely reviewer question, resubmission, or policy ambiguity:

- vague permission purpose strings
- incomplete review notes
- account deletion present but retention/provider cleanup unclear
- social/provider linking rules are unsafe or undocumented
- moderation exists but lacks escalation, blocking, or reporting evidence
- AI processing disclosure is unclear
- push notifications appear mandatory or expose private lock-screen content
- build doctor/export/lint warnings that suggest release hygiene drift

## P2 Polish

Not usually blocking, but improves acceptance and quality:

- screenshot coverage, feature graphic, release notes, store copy
- clearer support/terms/privacy links
- better demo seed data
- content rating precision
- cleaner App Review Notes or Play test instructions

## Unknowns

Use `Unknowns` for anything not proven from files, commands, browser inspection, or current official docs. Unknowns that may affect policy should usually be treated as P0 or P1 until verified.
