# Apple Review Preflight

Use with the current Apple App Review Guidelines and relevant Apple developer docs.

## App Completeness

- App launches cleanly on the submitted build.
- Core flows work with production/review backend, not local or staging-only services unless clearly intended for TestFlight.
- No visible dev tools, placeholder text, beta-only dead ends, fake buttons, or unfinished screens.
- Review notes explain any region, invite, role, 2FA, hardware, subscription, or seed-data requirement.

## Auth and Accounts

- If account creation exists, in-app account deletion exists and is not only email/support.
- If third-party/social login exists, check Apple login-services requirements.
- If 2FA exists, reviewer can complete login through provided instructions or demo recovery path.
- Account deletion explains retention for legally required, project-owned, transaction, audit, or evidence data.

## Privacy and Permissions

- Privacy policy is reachable in app and metadata.
- App Privacy answers match actual SDKs and app behavior.
- Native permission purpose strings are specific and human-readable.
- Permission prompts are contextual and app still handles denial gracefully where possible.
- Tracking/ads/data broker behavior is disclosed and gated as required.

## UGC, AI, and Safety

- UGC surfaces provide report and moderation paths; blocking/muting is present where policy requires.
- AI output can be reported/flagged when users can rely on or interact with it.
- Sensitive AI domains include appropriate disclaimers, support paths, or limitations.

## Metadata

- Screenshots match the submitted app and do not show hidden/unavailable features.
- Subtitle/description/keywords are accurate and avoid unsupported claims.
- Content rating matches UGC, AI, web access, user messaging, medical/financial content, and mature content.
- Support URL and marketing URL are live.

## Apple Official Source Anchors

- App Review Guidelines: https://developer.apple.com/app-store/review/guidelines/
- Account deletion: https://developer.apple.com/support/offering-account-deletion-in-your-app/
