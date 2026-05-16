# Console Form Fill Guide

Use this when preparing App Store Connect or Google Play Console submission details. The goal is to produce accurate, reviewer-friendly inputs, not marketing gloss. Verify final wording against the live console and current official policy.

## Operating Rules

- Base every answer on implemented behavior, SDK inventory, backend behavior, and policy docs.
- Mark uncertain answers as unknown instead of guessing; store forms can create legal/privacy exposure.
- Keep user-facing metadata accurate to the submitted build. Do not mention features hidden behind flags or planned for later.
- Prefer plain descriptions over clever copy in review notes, permission explanations, privacy answers, and tester instructions.
- Keep secrets out of store notes. Reference a secure location or account handoff process for credentials.
- Re-run this guide when SDKs, permissions, auth providers, account deletion, AI, UGC, payments, or tracking changes.

## Evidence To Collect First

- App identifiers: public app name, SKU/internal slug, bundle ID, package name, version, build number/version code.
- Release target: TestFlight, App Store review, Play internal, closed, open, production, staged/phased rollout.
- Auth and account flows: sign-up methods, sign-in methods, 2FA, account deletion, account linking, reviewer access.
- Data inventory: data collected, optional vs required, on-device only vs server, retention, deletion, export, third-party sharing.
- SDK inventory: auth, analytics, crash reporting, push, ads, attribution, payments, AI, support/chat, maps, storage/CDN.
- Permissions: iOS purpose strings, Android permissions, background modes, notification behavior.
- Safety features: UGC reporting, user blocking/muting, moderation, support contact, AI report/flag path.
- URLs: privacy policy, terms, support, marketing, account deletion web URL for Google Play.

## Apple App Store Connect Forms

### App Information

- Name/subtitle/category must describe the submitted app, not the roadmap.
- Choose the primary category by the user's main job-to-be-done, not the implementation stack.
- Use keywords for real search intent. Avoid competitor names, unrelated popular terms, or repeated title words.
- Support URL must be live and reachable without login.
- Marketing URL is optional unless it helps reviewers/users understand the app.

### App Privacy

Prepare answers from a data inventory:

```text
Data type:
Collected? yes/no
Required or optional:
Linked to user? yes/no
Used for tracking? yes/no
Purposes: app functionality, analytics, developer communications, advertising, fraud prevention, personalization, etc.
Shared with third parties/processors:
Retention/deletion behavior:
Evidence: code/config/SDK/provider docs
```

Common pitfalls:

- Crash logs, device identifiers, diagnostics, push tokens, and analytics events still count when collected.
- Auth providers may expose email, name, user ID, profile image, or identity tokens.
- Chat, attachments, voice notes, messages, and AI prompts can include user content.
- "Not linked to user" needs real support from implementation and vendor behavior.
- "Not tracking" must account for ads, attribution SDKs, cross-app identifiers, and data broker behavior.

### App Review Information

Include:

- demo account or demo mode path
- 2FA/recovery/test-code instructions
- seeded workspace/project/team role required to see meaningful content
- account deletion path
- paid/subscription/locked-feature notes
- hardware, region, or backend requirements
- UGC/AI reporting path when relevant

Do not include production secrets in notes. If credentials are sensitive, document a secure handoff path.

### Version Information

- What is new should match visible changes in the submitted build.
- Screenshots and previews must show the real app and current UI.
- Avoid beta/internal language unless submitting to TestFlight only.

## Google Play Console Forms

### App Content

Complete or prepare:

- Privacy Policy
- Data Safety
- App Access
- Ads
- Content Rating
- Target Audience and Content
- News, COVID/health, financial, government, gambling, or other sensitive declarations when applicable

### Data Safety

Prepare one row per data category:

```text
Data category:
Collected? yes/no
Shared? yes/no
Ephemeral processing? yes/no
Required or optional:
Purpose:
Encrypted in transit? yes/no
User can request deletion? yes/no
Evidence:
```

Check SDKs and backend providers, not just first-party code. Push tokens, crash data, analytics events, account identifiers, uploaded media, support messages, and AI prompts often affect Data Safety.

### Account Deletion

If users can create accounts:

- Provide in-app deletion path.
- Provide web deletion URL in Play Console.
- Explain deletion vs deactivation.
- Explain retained data and retention reasons.
- Ensure deletion path is reachable without unusual friction.
- Confirm push tokens, sessions, local auth, and provider links are cleaned up where applicable.

### App Access

Give reviewers a path that works on a fresh install:

- login method
- credentials handoff location or demo account instructions
- 2FA instructions
- required role/team/workspace
- steps to reach representative screens
- known limitations that are intentional

If the app is invite-only, role-based, region-limited, or requires seeded data, this section is a likely P0 unless instructions are precise.

## Store Listing Metadata

### Shared Principles

- The listing must match the submitted build.
- Lead with the app's core user value, not implementation details.
- Avoid unsupported superlatives, medical/financial/legal promises, and claims the app cannot prove.
- Do not mention Apple, Google, Android, iOS, or other brands in ways that violate metadata guidelines.
- Avoid keyword stuffing and unrelated terms.
- Mention account requirements, subscriptions, or required organization access when it prevents user confusion.

### Apple Metadata

- App name: clear and brand-safe.
- Subtitle: concise category/value statement.
- Promotional text: current, lightweight, and safe to change without build review.
- Description: what the app does, who it is for, and main workflows.
- Keywords: comma-separated search terms, no spaces after commas if character budget matters.
- Screenshots: current UI, correct device sizes, no misleading unavailable features.
- App preview: optional; if used, show real captured app behavior.

### Google Play Metadata

- Title: clear brand/category signal.
- Short description: high-intent value statement, not a slogan-only line.
- Full description: readable structure, real features, support/privacy cues, no keyword spam.
- Feature graphic: branded, legible, no tiny UI text, avoid misleading awards/badges.
- Screenshots: show real flows across phone/tablet targets as applicable.
- Release notes: specific enough for users, not internal commit language.

## Permission Explanations

For every permission, prepare:

```text
Permission:
Platform:
Prompt timing:
User-facing purpose:
Feature that requires it:
Behavior if denied:
Store disclosure impact:
Evidence:
```

Best practices:

- Ask at the moment of need.
- Make denial survivable unless the app's core purpose truly requires the permission.
- Keep lock-screen notification previews privacy-aware.
- Do not request permissions for planned features.

## Content Rating

Answer based on actual accessible content and user interactions:

- UGC, chat, web access, AI output, user profiles, media uploads, and moderation affect ratings.
- Do not understate mature, medical, financial, gambling, dating, or violence-related content.
- If content depends on user input, describe moderation and reporting controls in reviewer notes.

## Final Form Review Checklist

- Privacy policy, terms, support, and deletion URLs are live.
- App Privacy and Data Safety match the same data inventory.
- Permission strings and store disclosures match app behavior.
- Screenshots and metadata match the submitted build.
- App Access and App Review Notes let a reviewer reach seeded meaningful content.
- Account deletion instructions are present in app and Play Console web URL.
- UGC/AI reporting and moderation are described when relevant.
- Build identifiers, version numbers, release notes, and target tracks are correct.
