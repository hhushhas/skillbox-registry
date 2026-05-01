# Handoff Template

Use this structure for the session markdown file. Keep it concise and append-only.

```markdown
# <App> Store/Auth Preflight

Date: <YYYY-MM-DD>
Agent:
Browser:
Repo:

## Targets

- App name:
- iOS bundle ID:
- Android package:
- Expo account/project:
- Apple team:
- Play developer account:
- Google Cloud project:
- Production domain:

## Credential Storage

- Local credential directory:
- Secret handling: private key/password contents are not written in this note.

## Progress Log

### <HH:MM TZ>

- Action completed.
  - External ID:
  - URL:
  - Local file:
  - Expires:
  - Status:

## Locked External Identifiers

- Apple Developer Bundle ID:
- App Store Connect app name:
- App Store Connect app id:
- Google Play app name:
- Google Play package name:
- Google Play app id:
- Google Cloud project name:
- Google Cloud project id:
- Expo credential URL(s):

## OAuth / Auth Setup Notes

- Web OAuth client:
- iOS OAuth client:
- Android OAuth client, upload/dev SHA-1:
- Android OAuth client, Play App Signing SHA-1:
- Known blockers:

## Permissions Granted

- Apple/App Store Connect:
- Google Cloud IAM:
- Google Play Console:
- Expo:

## Pending Account Actions

- Pending item:
  - Why pending:
  - Exact next step:
  - Owner/account needed:
```
