# Google Play Preflight

Use with current Google Play Console policy pages.

## Build and Targeting

- Android package name, app signing, version code/name, and release track are correct.
- Target API level meets current Google Play requirements.
- AAB is generated from the intended mainline revision.
- Native permissions and SDK declarations match actual app behavior.

## User Data and Privacy

- Privacy policy is live, reachable, and matches Data Safety answers.
- Data Safety form accounts for analytics, crash reporting, push tokens, auth IDs, media uploads, AI processors, and third-party SDKs.
- Account deletion is available in app when account creation exists.
- Web deletion URL/path is available for Play's account deletion requirement and explains deletion vs retention.
- Data retention, export, and support/contact expectations are clear.

## UGC and AI

- UGC surfaces include reporting, moderation, abuse handling, and blocking/muting where required.
- AI-generated content policies are checked when the app creates or displays AI content.
- AI answers or generated content can be reported/flagged when users interact with or consume them.

## Store Listing

- App title, short description, full description, screenshots, feature graphic, category, contact details, and content rating are accurate.
- No misleading metadata, unrelated keywords, hidden functionality, or screenshots from unavailable screens.
- Tester/reviewer instructions include login, 2FA, seed data, roles, paid features, and region restrictions.

## Google Official Source Anchors

- User Data policy: https://support.google.com/googleplay/android-developer/answer/10144311
- Account deletion: https://support.google.com/googleplay/android-developer/answer/13327111
- User-generated content: https://support.google.com/googleplay/android-developer/answer/9876937
- AI-generated content: https://support.google.com/googleplay/android-developer/answer/13985936
- Target API: https://developer.android.com/google/play/requirements/target-sdk
