# Workflow Patterns

Use `@effect/workflow` for durable, resumable, interruptible workflows. It is a heavier tool than `Effect.gen`, queues, or ordinary background jobs, so start with the workflow fit before adding it.

## Good Fit

- long-running multi-step jobs
- compensation logic
- resumable operations
- externally visible execution ids
- work that must survive process restarts

## Poor Fit

- ordinary request handlers
- short transactional service methods
- simple one-shot background tasks
- code that only needs local concurrency or retry

## Definition Pattern

Keep workflow payload, success, and error schemas explicit. Use a stable idempotency key so retries and duplicate submissions do not create duplicate work.

```typescript
import { Workflow } from "@effect/workflow"
import { Effect, Schema } from "effect"

export const ProvisionTenant = Workflow.make({
    name: "ProvisionTenant",
    payload: Schema.Struct({ tenantId: TenantId }),
    idempotencyKey: (payload) => payload.tenantId,
    success: Schema.Struct({ tenantId: TenantId }),
    error: ProvisionTenantError,
})

export const ProvisionTenantLive = ProvisionTenant.toLayer((payload, executionId) =>
    Effect.gen(function* () {
        yield* Effect.log("Provisioning tenant", {
            tenantId: payload.tenantId,
            executionId,
        })

        yield* createTenant(payload.tenantId)
        yield* seedTenantDefaults(payload.tenantId)

        return { tenantId: payload.tenantId }
    }),
)
```

## Activity Boundaries

Use activities for external side effects that need durable retry semantics. Keep activities small, named, and idempotent where possible.

```typescript
import { Activity } from "@effect/workflow"

const SeedTenantDefaults = (tenantId: TenantId) =>
    Activity.make({
        name: "SeedTenantDefaults",
        error: SeedTenantDefaultsError,
        execute: Effect.gen(function* () {
            yield* tenantSeeder.seedDefaults(tenantId)
        }),
    }).pipe(Activity.retry({ times: 3 }))
```

Prefer activity names that map to real operational steps. Avoid large activities that hide several unrelated side effects behind one retry boundary.

## Layering

Provide workflow implementations at the app edge with the workflow engine/persistence layer required by the runtime. Keep the workflow definition importable from contract/shared packages when clients or RPC surfaces need to refer to it.

When a workflow coordinates services, depend on typed services inside the layer implementation rather than importing live constructors directly.

```typescript
export const ProvisionTenantLive = ProvisionTenant.toLayer((payload) =>
    Effect.gen(function* () {
        const tenants = yield* TenantService
        const billing = yield* BillingService

        yield* tenants.create(payload.tenantId)
        yield* billing.createCustomer(payload.tenantId)

        return { tenantId: payload.tenantId }
    }),
)
```

## Observability

Annotate logs/spans with the workflow name, execution id, idempotency key, and domain id. That is usually what you need when a workflow resumes, retries, or gets interrupted.

```typescript
yield* Effect.log("ProvisionTenant resumed").pipe(
    Effect.withSpan("Workflow.ProvisionTenant", {
        attributes: {
            tenantId: payload.tenantId,
            executionId,
        },
    }),
)
```

## Testing

Test the workflow behavior at two levels:

- Unit-test pure planning/validation helpers outside the workflow.
- Integration-test the workflow layer with test services and a test workflow engine/persistence layer when the repo has one.

Assert idempotency behavior for duplicate payloads when the workflow creates external resources.

## Avoid

- using Workflow for ordinary request/response service methods
- missing or unstable idempotency keys
- raw JSON payloads instead of schema-backed payloads
- activities that perform several unrelated external actions
- hiding all errors behind one generic workflow failure
- depending on concrete live services instead of typed service contracts
