# Feature-to-Policy Matrix

Use this as a trigger map. It is not a substitute for current official policy.

## Account and Auth

- Account creation: require an in-app account deletion path, privacy policy, support contact, and clear retention/deletion behavior.
- Third-party/social sign-in on iOS: check Apple login-services requirements and provide an Apple-compliant equivalent when required.
- Email/password plus social linking: link only verified identities; handle private relay/no-email/ambiguous collisions safely.
- 2FA or invite-only access: provide reviewer/demo instructions and a usable review path.
- Sign-out/session cleanup: clear tokens, local data that should not remain, and notification tokens as applicable.

## Data, Privacy, Tracking

- Analytics/crash/reporting SDKs: map collected data to App Privacy and Play Data Safety answers.
- Ads or cross-app tracking: check ATT, advertising ID, tracking disclosures, and opt-outs.
- Sensitive data: tighten collection, retention, consent, deletion, and support copy.
- Third-party processors: disclose where required and align privacy policy/store answers.

## User Content and Communication

- Chat, comments, profiles, attachments, voice notes, public posts: provide reporting, moderation, abusive-content handling, and blocking/muting where required.
- Private team/workspace content still counts as user-generated content if users create it.
- Attachments/media uploads: include prohibited-content reporting and removal paths.
- Push notifications: make permission optional; define preview privacy, badge counts, opt-out, token unregister, and tap behavior.

## AI Features

- AI-generated answers/content: provide reporting/flagging where required and avoid presenting output as authoritative in sensitive domains.
- Third-party AI processing: disclose project/user content processing and retention/no-training posture when applicable.
- AI moderation: do not rely only on automated moderation for high-risk UGC without an escalation/contact path.

## Permissions

- Microphone/camera/photos/location/contacts/Bluetooth/background modes: require clear native purpose strings and matching in-app behavior.
- Android permissions: declared permissions must match Play Data Safety and actual feature use.
- iOS entitlements/capabilities: capabilities must match real features and App Review notes.

## Commerce and Regulated Areas

- Digital goods/subscriptions: check Apple IAP and Google Play Billing rules.
- Physical goods/services: make refund/support/provider obligations clear.
- Kids, health, finance, crypto, gambling, dating, government, news: search current official policy and treat gaps as P0/P1 until verified.
