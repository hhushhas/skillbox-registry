---
name: default-typescript-stack
description: "[EXPLICIT INVOCATION ONLY] Hasan's default stack for new TypeScript apps/products."
---

# Default TypeScript Stack

Use for new TypeScript app/product decisions.

- Runtime: Node.js 24 LTS, TypeScript 6.
- Monorepo: pnpm + Turborepo, `apps/*`, `packages/*`.
- Web: `apps/web`, React 19 + TanStack Start.
- Mobile: `apps/mobile`; native iOS/Android, or Expo RN when sharing logic with web.
- Backend/data: Convex for DB, BaaS, and functions; use Convex plugins when useful.
- Auth: better-auth.
- UI: shadcn/ui + Tailwind CSS.
- Forms/validation: TanStack Form + Zod.
- TanStack: use Router, Query, Table, DB, Hotkeys, etc. when they fit.
- Lint: Oxlint.
- AI: Vercel AI SDK + OpenRouter adapter; streamdown for markdown streaming; Upstash Vector for RAG.
- Email: Resend + React Email.
- Payments: Stripe.
- Storage: Convex storage by default; Cloudflare R2 for object/public asset storage.
- Upstash: Redis, rate limiting, vector.
- Logs: Axiom.
- Deploy: Cloudflare Workers with Wrangler; `cf` CLI may be available.
