---
name: mobile-store-submission-readiness
description: "Preflight mobile apps for Apple App Store and Google Play submission readiness. Use when Codex is asked whether an iOS/Android app is store-ready, to prepare App Review or Play Console submission details, to avoid mobile store rejection, to audit privacy/data safety/account deletion/sign-in/UGC/AI/permissions/build metadata, or to produce a rejection-risk report before release."
---

# Mobile Store Submission Readiness

Use this skill as a pre-submission reviewer for mobile apps. The goal is to catch preventable App Store and Google Play rejection risks before a real review.

Treat official Apple and Google documentation as the final authority. This skill provides the workflow, common risk map, and output format; browse current official docs before advising that an app is store-ready or finalizing submission copy.

## Start Here

1. Discover the app facts from repo files before giving advice:
   - app name, bundle ID, package name, platforms, framework, build system, release lane
   - auth methods, account creation, account deletion, 2FA/reviewer access
   - payments, subscriptions, commerce, ads, tracking, analytics SDKs
   - user-generated content, chat/social features, moderation, reporting, blocking
   - AI-generated content, third-party AI processing, AI reporting/disclosure
   - permissions: push, camera, mic, photos, contacts, location, Bluetooth, background modes
   - sensitive domains: kids, health, finance, crypto, gambling, dating, government, news, regulated content
   - privacy policy, terms, support URL/email, data export/deletion paths

2. Read only the references needed for the app:
   - Feature-to-policy mapping: `references/feature-to-policy-matrix.md`
   - Apple-focused review pass: `references/apple-review-preflight.md`
   - Google Play-focused review pass: `references/google-play-preflight.md`
   - Console form and store listing guidance: `references/console-form-fill-guide.md`
   - Report severity and output shape: `references/rejection-risk-taxonomy.md`
   - Review notes and submission copy: `references/submission-packet-template.md`

3. Run a store-readiness pass:
   - inspect config, manifests, entitlements, native permission strings, package metadata, release scripts, docs, and app flows
   - run available local checks when feasible: typecheck, lint, tests, native export/build/doctor commands, manifest validation
   - verify claims against real files or commands; mark unverified items as unknowns
   - browse official Apple/Google docs for current policy wording when policy details matter

## Official Sources

Prefer official sources over blog posts or memory:

- Apple App Review Guidelines: https://developer.apple.com/app-store/review/guidelines/
- Apple account deletion guidance: https://developer.apple.com/support/offering-account-deletion-in-your-app/
- Google Play User Data policy: https://support.google.com/googleplay/android-developer/answer/10144311
- Google Play account deletion requirements: https://support.google.com/googleplay/android-developer/answer/13327111
- Google Play user-generated content policy: https://support.google.com/googleplay/android-developer/answer/9876937
- Google Play AI-generated content policy: https://support.google.com/googleplay/android-developer/answer/13985936
- Android target API requirements: https://developer.android.com/google/play/requirements/target-sdk

If the app uses payments, kids/family features, health, finance, crypto, gambling, background location, subscriptions, ads, or tracking, find and cite the relevant current official policy pages too.

## Required Output

Lead with findings, not a generic checklist:

```text
P0 Blockers
- [area] Risk, evidence, why it likely blocks submission, fix.

P1 High Risk
- [area] Risk, evidence, likely reviewer concern, fix.

P2 Polish
- [area] Improvement, evidence, recommendation.

Unknowns
- Fact that could not be verified, where to check next.

Submission Packet
- Apple Review Notes draft.
- Google Play testing instructions draft.
- Demo account / 2FA path.
- Privacy/Data Safety inputs.
- Store listing metadata and asset guidance.
- Permission explanations.
- Account deletion path and URL.
- UGC/AI moderation explanation.
- Build/version/release checklist.

Evidence Checked
- Files, commands, build artifacts, docs, URLs.
```

## Severity Rules

Use `P0 Blocker` for likely rejection or cannot-submit issues: crashes, broken login, unavailable backend, no reviewer access, missing account deletion when account creation exists, iOS third-party login without Apple-compliant option, missing privacy policy, severe privacy/data-safety mismatch, missing UGC moderation/reporting when required, undeclared permissions, expired/invalid credentials, or target SDK/build failures.

Use `P1 High Risk` for issues likely to trigger reviewer questions or resubmission: vague permission copy, incomplete review notes, ambiguous data retention, weak AI disclosure/reporting, partial moderation, mismatch between screenshots and app behavior, invite-only paths without reviewer instructions, or build hygiene failures that do not currently block local bundling.

Use `P2 Polish` for store conversion and clarity: screenshots, feature graphic, release notes, metadata phrasing, support copy, content rating precision, and reviewer-friendly demo data.

## Guardrails

- Do not claim store readiness without evidence and current official policy checks.
- Do not paste secrets, private keys, keystore passwords, service account JSON contents, `.p8`, `.p12`, or reviewer passwords in chat.
- If using a demo account, describe the path and where credentials should be stored; do not expose the credentials unless the user explicitly requests and the medium is appropriate.
- Keep project-specific decisions in the project repo/spec. Keep this skill project-agnostic.
- When updating a repo spec, reference this skill as the submission-readiness workflow and official docs as policy authority.
