---
name: effect-best-practices
description: Applies the project's Effect-TS style for backend services, errors, schemas, layers, config, logging, and typed Effect composition. Use when writing or reviewing Effect.Service, Schema.TaggedError, Layer composition, Config, Effect.fn, Option, or domain schemas.
version: 1.0.0
disable-model-invocation: true
---

# Effect-TS Project Style

This skill captures a project style for Effect-TS backend code. Treat it as a strong default, then follow the surrounding codebase when it has a clear local pattern.

## Effect Language Server

For Effect-heavy packages, add `@effect/language-service` and keep it enabled in the package `tsconfig.json`.

After meaningful Effect changes, run the Effect Language Service diagnostics for the touched package so Effect-specific warnings and bad-practice hints are visible before handoff.

For setup, CLI details, build-time diagnostics, and editor caveats, see `references/language-server.md`.

## Quick Reference

| Category | Prefer | Avoid in core domain code |
|----------|--------|---------------------------|
| Services | `Effect.Service` for owned services; `Context.Service` for explicit service contracts | `Context.Tag` for owned business services |
| Dependencies | `dependencies: [Dep.Default]` in service | Wiring business dependencies at every usage site |
| Layers | `Layer.mergeAll` for flat composition | Deeply nested `Layer.provide` chains |
| Layer Chaining | `Layer.provideMerge` for incremental composition | Repeated `Layer.provide` when it makes types harder to read |
| Errors | `Schema.TaggedError` with `message` and useful context | Plain `Error` or generic HTTP-shaped errors for domain failures |
| Error Specificity | `UserNotFoundError`, `SessionExpiredError` | Collapsing distinct failures into `NotFoundError` / `BadRequestError` |
| Error Handling | `catchTag` / `catchTags` for known errors | Broad `catchAll` / `mapError` that erases useful error shape |
| IDs | `Schema.UUID.pipe(Schema.brand("@App/EntityId"))` | Plain `string` for entity IDs crossing service boundaries |
| Functions | `Effect.fn("Service.method")` for service methods | Anonymous service methods with poor tracing |
| Logging | `Effect.log*` with structured data | `console.log` in services and long-lived app code |
| Config | `Config.*` with validation | Direct `process.env` reads in service code |
| JSON | `Schema.parseJson`, `Schema.decode*`, or codecs | Raw `JSON.parse` / `JSON.stringify` |
| Options | `Option.match`, `Option.getOrElse`, or typed failures | `Option.getOrThrow` in recoverable paths |
| Nullability | `Option<T>` in domain schemas | `null` / `undefined` as ordinary domain absence |

## Service Definition Pattern

Prefer `Effect.Service` for owned business logic services. It provides accessors, a built-in `Default` layer, and a standard place to declare dependencies. Use `Context.Service` when the service contract and implementation should be intentionally separate, such as adapters, ports, or integration boundaries.

```typescript
import { Effect } from "effect"

export class UserService extends Effect.Service<UserService>()("UserService", {
    accessors: true,
    dependencies: [UserRepo.Default, CacheService.Default],
    effect: Effect.gen(function* () {
        const repo = yield* UserRepo
        const cache = yield* CacheService

        const findById = Effect.fn("UserService.findById")(function* (id: UserId) {
            const cached = yield* cache.get(id)
            if (Option.isSome(cached)) return cached.value

            const user = yield* repo.findById(id)
            yield* cache.set(id, user)
            return user
        })

        const create = Effect.fn("UserService.create")(function* (data: CreateUserInput) {
            const user = yield* repo.create(data)
            yield* Effect.log("User created", { userId: user.id })
            return user
        })

        return { findById, create }
    }),
}) {}

// Usage - dependencies are already wired
const program = Effect.gen(function* () {
    const user = yield* UserService.findById(userId)
    return user
})

// At app root
const MainLive = Layer.mergeAll(UserService.Default, OtherService.Default)
```

**When `Context.Tag` / `Context.Service` is acceptable:**
- `Context.Service`: explicit service interfaces, adapters, ports, and replaceable integrations
- `Context.Tag`: runtime-provided infrastructure values such as Cloudflare KV/R2 bindings
- Library-provided tags such as platform, SQL, HTTP, and runtime services

See `references/service-patterns.md` for detailed patterns.

## Error Definition Pattern

Prefer `Schema.TaggedError` for domain and API boundary errors. It keeps errors serializable and gives `catchTag` / `catchTags` a stable discriminator.

```typescript
import { Schema } from "effect"
import { HttpApiSchema } from "@effect/platform"

export class UserNotFoundError extends Schema.TaggedError<UserNotFoundError>()(
    "UserNotFoundError",
    {
        userId: UserId,
        message: Schema.String,
    },
    HttpApiSchema.annotations({ status: 404 }),
) {}

export class UserCreateError extends Schema.TaggedError<UserCreateError>()(
    "UserCreateError",
    {
        message: Schema.String,
        cause: Schema.optional(Schema.String),
    },
    HttpApiSchema.annotations({ status: 400 }),
) {}
```

**Error handling - use `catchTag`/`catchTags`:**

```typescript
// CORRECT - preserves type information
yield* repo.findById(id).pipe(
    Effect.catchTag("DatabaseError", (err) =>
        Effect.fail(new UserNotFoundError({ userId: id, message: "Lookup failed" }))
    ),
    Effect.catchTag("ConnectionError", (err) =>
        Effect.fail(new ServiceUnavailableError({ message: "Database unreachable" }))
    ),
)

// CORRECT - multiple tags at once
yield* effect.pipe(
    Effect.catchTags({
        DatabaseError: (err) => Effect.fail(new UserNotFoundError({ userId: id, message: err.message })),
        ValidationError: (err) => Effect.fail(new InvalidEmailError({ email: input.email, message: err.message })),
    }),
)
```

### Prefer Explicit Over Generic Errors

Give distinct recoverable failure reasons their own error type. Do not collapse unrelated failures into generic HTTP errors when callers or UI need to react differently.

```typescript
// WRONG - Generic errors lose information
export class NotFoundError extends Schema.TaggedError<NotFoundError>()(
    "NotFoundError",
    { message: Schema.String },
    HttpApiSchema.annotations({ status: 404 }),
) {}

// Then mapping everything to it:
Effect.catchTags({
    UserNotFoundError: (err) => Effect.fail(new NotFoundError({ message: "Not found" })),
    ChannelNotFoundError: (err) => Effect.fail(new NotFoundError({ message: "Not found" })),
    MessageNotFoundError: (err) => Effect.fail(new NotFoundError({ message: "Not found" })),
})
// Frontend gets useless: { _tag: "NotFoundError", message: "Not found" }
// Which resource? User? Channel? Message? Can't tell!
```

```typescript
// CORRECT - Explicit domain errors with rich context
export class UserNotFoundError extends Schema.TaggedError<UserNotFoundError>()(
    "UserNotFoundError",
    { userId: UserId, message: Schema.String },
    HttpApiSchema.annotations({ status: 404 }),
) {}

export class ChannelNotFoundError extends Schema.TaggedError<ChannelNotFoundError>()(
    "ChannelNotFoundError",
    { channelId: ChannelId, message: Schema.String },
    HttpApiSchema.annotations({ status: 404 }),
) {}

export class SessionExpiredError extends Schema.TaggedError<SessionExpiredError>()(
    "SessionExpiredError",
    { sessionId: SessionId, expiredAt: Schema.DateTimeUtc, message: Schema.String },
    HttpApiSchema.annotations({ status: 401 }),
) {}

// Frontend can now show specific UI:
// - UserNotFoundError → "User doesn't exist"
// - ChannelNotFoundError → "Channel was deleted"
// - SessionExpiredError → "Your session expired. Please log in again."
```

See `references/error-patterns.md` for error remapping and retry patterns.

## Schema & Branded Types Pattern

Brand entity IDs that cross service boundaries:

```typescript
import { Schema } from "effect"

// Entity IDs - brand values that cross service boundaries
export const UserId = Schema.UUID.pipe(Schema.brand("@App/UserId"))
export type UserId = Schema.Schema.Type<typeof UserId>

export const OrganizationId = Schema.UUID.pipe(Schema.brand("@App/OrganizationId"))
export type OrganizationId = Schema.Schema.Type<typeof OrganizationId>

// Domain types - use Schema.Struct
export const User = Schema.Struct({
    id: UserId,
    email: Schema.String,
    name: Schema.String,
    organizationId: OrganizationId,
    createdAt: Schema.DateTimeUtc,
})
export type User = Schema.Schema.Type<typeof User>

// Input types for mutations
export const CreateUserInput = Schema.Struct({
    email: Schema.String.pipe(Schema.pattern(/^[^\s@]+@[^\s@]+\.[^\s@]+$/)),
    name: Schema.String.pipe(Schema.minLength(1)),
    organizationId: OrganizationId,
})
export type CreateUserInput = Schema.Schema.Type<typeof CreateUserInput>
```

**When NOT to brand:**
- Simple strings that don't cross service boundaries (URLs, file paths)
- Primitive config values

See `references/schema-patterns.md` for transforms and advanced patterns.

## Function Pattern with Effect.fn

Use `Effect.fn` for service methods so traces and stack traces carry useful names:

```typescript
// CORRECT - Effect.fn with descriptive name
const findById = Effect.fn("UserService.findById")(function* (id: UserId) {
    yield* Effect.annotateCurrentSpan("userId", id)
    const user = yield* repo.findById(id)
    return user
})

// CORRECT - Effect.fn with multiple parameters
const transfer = Effect.fn("AccountService.transfer")(
    function* (fromId: AccountId, toId: AccountId, amount: number) {
        yield* Effect.annotateCurrentSpan("fromId", fromId)
        yield* Effect.annotateCurrentSpan("toId", toId)
        yield* Effect.annotateCurrentSpan("amount", amount)
        // ...
    }
)
```

## Layer Composition

Declare business dependencies in the service rather than at every usage site:

```typescript
// CORRECT - dependencies in service definition
export class OrderService extends Effect.Service<OrderService>()("OrderService", {
    accessors: true,
    dependencies: [
        UserService.Default,
        ProductService.Default,
        PaymentService.Default,
    ],
    effect: Effect.gen(function* () {
        const users = yield* UserService
        const products = yield* ProductService
        const payments = yield* PaymentService
        // ...
    }),
}) {}

// At app root - simple merge
const AppLive = Layer.mergeAll(
    OrderService.Default,
    // Infrastructure layers (intentionally not in dependencies)
    DatabaseLive,
    RedisLive,
)
```

**Layer composition patterns:**

```typescript
// Use Layer.mergeAll for flat composition of same-level layers
const RepoLive = Layer.mergeAll(
    UserRepo.Default,
    OrderRepo.Default,
    ProductRepo.Default,
)

// Use Layer.provideMerge for incremental chaining (flatter types than Layer.provide)
const MainLive = DatabaseLive.pipe(
    Layer.provideMerge(ConfigServiceLive),
    Layer.provideMerge(LoggerLive),
    Layer.provideMerge(CacheLive),
)
```

**Why layers over `Effect.provide`:**
- **Deduplication**: Layers memoize construction - same service instantiated once. `Effect.provide` creates new instances each call.
- **TypeScript performance**: Deep `Layer.provide` nesting creates complex recursive types that slow the LSP. `Layer.mergeAll` and `Layer.provideMerge` produce flatter types.
- **Resource management**: Scoped layers properly share and clean up resources.

See `references/layer-patterns.md` for testing layers, config-dependent layers, and the `layerConfig` pattern.

## Option Handling

Avoid `Option.getOrThrow` in recoverable paths. Handle both cases explicitly or provide a default:

```typescript
// CORRECT - explicit handling
yield* Option.match(maybeUser, {
    onNone: () => Effect.fail(new UserNotFoundError({ userId, message: "Not found" })),
    onSome: (user) => Effect.succeed(user),
})

// CORRECT - with getOrElse for defaults
const name = Option.getOrElse(maybeName, () => "Anonymous")

// CORRECT - Option.map for transformations
const upperName = Option.map(maybeName, (n) => n.toUpperCase())
```

## Pitfalls To Avoid

These patterns are usually a problem in service/domain code. Boundary code, tests, scripts, or migration glue may need exceptions; keep those exceptions small and intentional.

```typescript
// Avoid running effects inside services; return/yield Effects instead.
const result = Effect.runSync(someEffect)

// Avoid throwing for expected failures inside Effect.gen.
yield* Effect.gen(function* () {
    if (bad) throw new Error("No!") // Use Effect.fail for typed failures.
})

// Avoid catchAll when it erases useful error types.
yield* effect.pipe(Effect.catchAll(() => Effect.fail(new GenericError())))

// Avoid console logging in services.
console.log("debug") // Use Effect.log

// Avoid direct process.env reads in service code.
const key = process.env.API_KEY // Use Config.string("API_KEY")

// Avoid raw JSON parsing/stringifying.
const parsed = JSON.parse(input) // Use Schema.parseJson(MySchema) + Schema.decode*

// Avoid null/undefined as ordinary domain absence.
type User = { name: string | null } // Use Option<string>
```

See `references/anti-patterns.md` for the complete list with rationale.

## Observability

```typescript
// Structured logging
yield* Effect.log("Processing order", { orderId, userId, amount })

// Metrics
const orderCounter = Metric.counter("orders_processed")
yield* Metric.increment(orderCounter)
```

See `references/config-patterns.md` for config loading, validation, redaction, layer construction, and JSON/env boundaries.
See `references/observability-patterns.md` for metrics and tracing patterns.

## Reference Files

For detailed patterns, consult these reference files in the `references/` directory:

- `language-server.md` - Effect Language Service setup, diagnostics, refactors, CLI tools
- `service-patterns.md` - Service definition, Effect.fn, Context.Tag exceptions
- `error-patterns.md` - Schema.TaggedError, error remapping, retry patterns
- `schema-patterns.md` - Branded types, transforms, Schema.Class
- `layer-patterns.md` - Dependency composition, testing layers
- `config-patterns.md` - Config, redaction, validation, layer construction, JSON boundaries
- `effect-modules.md` - Effect Platform, HttpApi, HttpClient, Rpc guidance
- `workflow-patterns.md` - Durable workflow fit, activity boundaries, layering, testing
- `anti-patterns.md` - Common pitfalls and safer alternatives
- `observability-patterns.md` - Logging, metrics, config patterns

If the references do not answer a question, inspect the local codebase first. For Effect API behavior or unclear module usage, clone or update the Effect repository and search the source, tests, examples, and package READMEs before guessing.
