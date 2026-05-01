# Config Patterns

Configuration is an Effect boundary. Prefer `Config.*` for environment-backed values, `Schema` for decoded file/JSON payloads, and redacted values for secrets. Avoid manual `process.env` parsing in services.

## Basic Config

```typescript
import { Config, Effect, Layer, Redacted } from "effect"

const ApiConfig = Config.all({
    baseUrl: Config.string("API_BASE_URL"),
    apiKey: Config.redacted("API_KEY"),
    timeoutMs: Config.integer("API_TIMEOUT_MS").pipe(
        Config.withDefault(5_000),
        Config.validate({
            message: "API_TIMEOUT_MS must be positive",
            validation: (n) => n > 0,
        }),
    ),
})

const program = Effect.gen(function* () {
    const config = yield* ApiConfig
    const apiKey = Redacted.value(config.apiKey)
    return { ...config, apiKey }
})
```

## Group Config Near The Consumer

Keep config close to the service or layer that owns it. Do not create a global config bag unless the values truly belong together.

```typescript
const TelemetryConfig = Config.all({
    enabled: Config.boolean("TELEMETRY_ENABLED").pipe(Config.withDefault(true)),
    endpoint: Config.string("TELEMETRY_ENDPOINT"),
    batchSize: Config.integer("TELEMETRY_BATCH_SIZE").pipe(Config.withDefault(20)),
})

export const TelemetryLive = Layer.effect(
    Telemetry,
    Effect.gen(function* () {
        const config = yield* TelemetryConfig
        return makeTelemetry(config)
    }),
)
```

## Config-Dependent Layers

Use `Layer.unwrapEffect` when config decides which layer to provide.

```typescript
export const TracingLive = Layer.unwrapEffect(
    Effect.gen(function* () {
        const endpoint = yield* Config.option(Config.string("OTEL_EXPORTER_OTLP_ENDPOINT"))
        if (endpoint._tag === "None") {
            return Layer.empty
        }

        return makeOtelLayer(endpoint.value)
    }),
)
```

Use a `layerConfig` helper when a service accepts a configurable shape and tests need to override it cleanly.

```typescript
interface QueueConfig {
    readonly batchSize: number
    readonly pollIntervalMs: number
}

export class EventQueue extends Effect.Service<EventQueue>()("EventQueue", {
    effect: Effect.gen(function* () {
        return makeQueue({ batchSize: 100, pollIntervalMs: 1_000 })
    }),
}) {
    static readonly layerConfig = (config: Config.Config.Wrap<QueueConfig>) =>
        Layer.effect(
            EventQueue,
            Config.unwrap(config).pipe(Effect.map(makeQueue)),
        )
}
```

## JSON And File Config

Raw JSON parsing is not acceptable at boundaries. Decode through `Schema.parseJson` or an equivalent schema-backed codec.

```typescript
import { FileSystem } from "@effect/platform"
import { Schema } from "effect"

const ProviderConfig = Schema.Struct({
    provider: Schema.Literal("openai", "anthropic"),
    model: Schema.NonEmptyString,
})

const ProviderConfigJson = Schema.parseJson(ProviderConfig)

const loadProviderConfig = Effect.fn("Config.loadProviderConfig")(function* (path: string) {
    const fs = yield* FileSystem.FileSystem
    const text = yield* fs.readFileString(path)
    return yield* Schema.decodeUnknownEffect(ProviderConfigJson)(text)
})
```

## Secrets

Use `Config.redacted` for secrets. Keep the redacted value redacted until the smallest possible call site.

```typescript
const Secrets = Config.all({
    apiKey: Config.redacted("API_KEY"),
})

const callProvider = Effect.fn("Provider.call")(function* () {
    const { apiKey } = yield* Secrets
    return yield* providerCall(Redacted.value(apiKey))
})
```

## Avoid

- `process.env` reads inside services
- `parseInt(process.env.PORT || "3000")`
- raw `JSON.parse` / `JSON.stringify`
- unredacted secrets in logs, spans, or error messages
- one app-wide config object that every service depends on
