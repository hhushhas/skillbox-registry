---
name: mobile-app-provisioning
description: End-to-end provisioning for a new Expo/React Native app across Expo EAS, Google Cloud Auth/FCM, Google Play Console, Apple Developer, and App Store Connect. Use when creating store apps, signing credentials, push keys, OAuth clients, EAS Submit credentials, Play/App Store records, or repeatable launch handoff notes.
disable-model-invocation: true
---

# Mobile App Provisioning

Use this for complete, auditable mobile app setup. The goal is not "enough to build once"; the goal is a credential and store posture that will not haunt the project later.

## Defaults

- Prefer the browser the user named. If they say Helium, use Helium.
- Keep a markdown session/handoff file in the repo, usually `scratchpad/<app>-store-auth-preflight-YYYY-MM-DD.md`.
- Store secret files under `scratchpad/credentials/` unless the user gives another secure path.
- Never paste private keys, passwords, `.p8`, `.p12`, service account JSON contents, or keystore passwords in chat or notes.
- Record file paths, IDs, expiry dates, account/team names, selected permissions, and exact pending blockers.
- Confirm at action-time before creating long-lived API keys, service account keys, OAuth keys, or granting external account access.
- Use least privilege unless the user explicitly wants broader release automation.

## Load When Needed

- For the concrete checklist, read `references/checklist.md`.
- For the final note format, read `references/handoff-template.md`.

## Complete Job Definition

A complete provisioning pass must account for all of these, either configured or explicitly marked pending with the exact blocker:

```text
Apple
  Apple Developer App ID
  App Store Connect app record
  iOS distribution certificate
  App Store provisioning profile
  APNs auth key
  App Store Connect API key for EAS Submit
  Expo iOS credential upload

Android
  Google Play app shell
  Android upload keystore
  Google Cloud project
  Google Auth Platform branding/audience
  FCM V1 service account/key
  Google Play/EAS Submit service account/key
  Play Console app-specific service-account permissions
  Expo Android credential upload

OAuth
  Web OAuth client with production and local callback URIs
  iOS OAuth client with bundle ID
  Android OAuth client for upload/dev certificate SHA-1
  Android OAuth client for Google Play App Signing SHA-1
```

Do not call Android OAuth complete until both Android SHA-1 paths are handled:

```text
EAS/dev/internal builds
  package: <android.package>
  SHA-1: upload/dev keystore certificate

Play Store distributed builds
  package: <android.package>
  SHA-1: Google Play App Signing certificate
```

It is valid to leave Play App Signing SHA-1 pending before the first AAB/signing setup, but the handoff must say exactly where it will come from and that a second Android OAuth client is still required.

## Operating Workflow

1. Gather app facts:
   - public app name, internal/project slug, iOS bundle ID, Android package name
   - Expo account/project URL
   - Apple team and App Store Connect account
   - Play developer account and app target
   - Google Cloud project target
   - auth domain and callback shape
   - release automation scope: testing only or production too

2. Create/update the markdown handoff before risky work:
   - write inputs, accounts, target identifiers, and date
   - append progress with timestamps
   - keep secrets out

3. Provision Apple/iOS:
   - create App ID with required capabilities, especially Push Notifications
   - create App Store Connect app record
   - create fresh distribution certificate only when needed
   - create App Store profile
   - create APNs key, normally production
   - create ASC API key for EAS Submit
   - upload credentials to Expo and verify Expo status

4. Provision Android/Google:
   - create Play app shell with package name
   - generate Android upload keystore and record fingerprints
   - upload keystore to Expo
   - create/configure Google Cloud project and Google Auth Platform
   - enable required APIs
   - create FCM V1 service account/key and upload to Expo
   - create Play/EAS Submit service account/key and upload to Expo
   - grant Play Console app-specific permissions

5. Provision OAuth:
   - web client only after callback URIs are known
   - iOS client with bundle ID
   - Android client for upload/dev SHA-1
   - Android client for Play App Signing SHA-1 after available

6. Verify:
   - Expo credential pages show valid/accepted credentials
   - Play Console user/service account shows active
   - Google Cloud IAM roles and enabled services are visible
   - Apple cert/profile/key IDs and expiry dates are recorded

## Permission Guidance

For Google Play EAS Submit service accounts, prefer app-specific access:

```text
Required baseline:
  View app information (read only)
  View app quality information (read-only)
  Release apps to testing tracks

Optional, only if intended:
  Release to production, exclude devices and use Play app signing
  Manage store presence
  Manage testing tracks and edit tester lists
```

If automated production rollout is not explicitly requested, do not grant production release permission.

## Handoff Rules

End with:

- what is fully done
- what is pending and why
- exact local notes path
- exact secret file paths, without contents
- exact external IDs and expiry dates
- exact permissions granted
- whether production release permissions were granted

If blocked, include the exact browser URL, UI state, missing account permission, or error text.
