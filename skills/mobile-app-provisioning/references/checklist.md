# Provisioning Checklist

Use this as the working checklist for a new Expo mobile app.

## Inputs

```text
App public name:
Internal slug:
iOS bundle ID:
Android package name:
Expo account:
Expo project URL:
Apple team:
App Store Connect account:
Play developer account:
Google Cloud account/project:
Production domain:
Auth callback route:
Release automation scope: testing only | production too
```

## Apple / iOS

- Apple Developer App ID exists for the bundle ID.
- Required capabilities are enabled.
- App Store Connect app exists.
- Distribution certificate exists and expiry is recorded.
- App Store provisioning profile exists and expiry is recorded.
- APNs auth key exists, key ID/team ID recorded, environment recorded.
- App Store Connect API key exists, key ID/issuer ID/role recorded.
- Expo iOS credentials show valid distribution certificate.
- Expo iOS credentials show valid provisioning profile.
- Expo iOS credentials show APNs key uploaded.
- Expo iOS credentials show ASC API key uploaded.

## Android / Google

- Google Play app shell exists.
- Package name is final.
- Android upload keystore exists in local credentials.
- Upload keystore SHA-1 and SHA-256 are recorded.
- Expo Android credentials show upload keystore uploaded.
- Google Cloud project exists.
- Google Auth Platform branding/audience/contact is configured.
- Required Google APIs are enabled:
  - `firebase.googleapis.com`
  - `fcm.googleapis.com`
  - `androidpublisher.googleapis.com`
  - `iam.googleapis.com`
  - `cloudresourcemanager.googleapis.com`
- FCM V1 service account/key exists.
- FCM service account has the FCM role needed by the app.
- FCM key is uploaded to Expo Android credentials.
- Play/EAS Submit service account/key exists.
- Play/EAS Submit key is uploaded to Expo Android credentials.
- Play Console grants the submit service account app-specific access.

## OAuth

- Web OAuth client exists with production callback URI.
- Web OAuth client includes local/dev callback URI if needed.
- iOS OAuth client exists for the bundle ID.
- Android OAuth client exists for upload/dev certificate SHA-1.
- Android OAuth client exists for Google Play App Signing SHA-1.
- If Play App Signing SHA-1 is not available yet, the handoff states the exact blocker and next step.

## Final Verification

- Secret files exist locally and are chmod/private enough for the machine.
- Notes file contains no private keys or passwords.
- Notes file records external IDs, expiry dates, permissions, and pending blockers.
- No production release permission was granted unless explicitly requested.
