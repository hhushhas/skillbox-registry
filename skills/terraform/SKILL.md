---
name: terraform
description: Umbrella skill for Terraform authoring. Use for Terraform module design, code generation, and style/structure best practices.
disable-model-invocation: true
---

# Terraform

Use this as the single entrypoint for Terraform work.

## Use for

- writing Terraform
- reviewing Terraform
- building reusable modules
- shaping file structure and style
- module library design

## Routing

- reusable module patterns:
  `/Users/macmini/.agents/skills-archive/terraform/terraform-module-library`
- style and code generation conventions:
  `/Users/macmini/.agents/skills-archive/terraform/terraform-style-guide`

## Default behavior

1. If the task is about reusable building blocks, open module-library.
2. If the task is about code style/shape/review, open style-guide.
3. If both matter, open both, but keep Terraform as the only visible entrypoint.

## Rule

Keep Terraform surfaced as one skill, not multiple narrow siblings.
