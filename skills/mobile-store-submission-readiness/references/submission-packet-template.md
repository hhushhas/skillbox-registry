# Submission Packet Template

Adapt this to the project. Do not include secrets in chat or public files.

## Apple Review Notes

```text
App purpose:
<one concise paragraph>

Reviewer access:
- Account: <where credentials are stored or how reviewer gets them>
- 2FA: <test code/recovery/instructions>
- Required role/workspace/project: <seeded path>

Key flows to test:
1. <flow>
2. <flow>
3. <flow>

Permissions used:
- <permission>: <why and where prompted>

Account deletion:
- In-app path: <path>
- Retention summary: <what is deleted, retained, and why>

UGC/AI safety:
- Reporting path: <path>
- Blocking/muting/moderation: <path/process>
- AI disclosure/reporting: <path/process>

Notes:
<backend availability, region restrictions, subscriptions, hardware, or feature flags>
```

## Google Play Testing Instructions

```text
Tester access:
- Account: <where credentials are stored or how reviewer gets them>
- 2FA: <test code/recovery/instructions>
- Seeded data: <workspace/project/path>

Required test flows:
1. <flow>
2. <flow>
3. <flow>

Account deletion:
- In-app path: <path>
- Web deletion URL: <url>
- Retention summary: <what is deleted, retained, and why>

Data Safety notes:
- Data collected: <summary>
- Third parties/processors: <summary>
- Optional permissions: <summary>

UGC/AI:
- Reporting/moderation: <summary>
- AI-generated content controls: <summary>
```

## Evidence Checklist

- App config/manifest/entitlements checked:
- Privacy policy/terms/support checked:
- Account deletion checked:
- Permission strings checked:
- App Privacy/Data Safety inputs drafted:
- Content rating inputs drafted:
- Store metadata/screenshots checked:
- Build/export/doctor commands run:
- Official Apple/Google docs checked on:
