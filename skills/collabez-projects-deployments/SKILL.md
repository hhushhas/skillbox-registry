---
name: collabez-projects-deployments
description: Umbrella skill for project-specific deployments across CollabDash, ET LMS, and TH LMS. Use for shipping, release verification, Amplify, S3 + CloudFront, EC2, Docker Compose, PM2, and Chalk-version rollout work on these projects.
disable-model-invocation: true
---

# Collabez Projects Deployments

Use this as the single entrypoint for project-specific deployment work.

## Use for

- shipping CollabDash
- shipping ET LMS
- shipping TH LMS
- Chalk version rollout across those projects
- Amplify / S3 + CloudFront / EC2 / Docker Compose / PM2 deploy debugging
- release verification and smoke checks

## Routing

- CollabDash:
  `/Users/macmini/.agents/skills-archive/collabez-projects-deployments/collabdash-deploy`
- ET LMS:
  `/Users/macmini/.agents/skills-archive/collabez-projects-deployments/et-lms-deploy`
- TH LMS:
  `/Users/macmini/.agents/skills-archive/collabez-projects-deployments/th-lms-deploy`

## Default behavior

1. Identify target project first.
2. Open only that archived deploy skill.
3. Follow its live workflow doc, gate, push, CI watch, and deploy verification steps.

## Rule

Keep these deploy routines under one visible umbrella. Do not restore the three project deploy skills as separate top-level skills unless there is a strong need.
