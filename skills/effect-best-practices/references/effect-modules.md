# Effect Modules

Keep module-specific guidance here so the main skill stays small. These are project defaults for Effect Platform, HttpApi, HttpClient, and Rpc.

## Effect Platform

Prefer platform services over direct Node or runtime globals in long-lived app code:

- `FileSystem.FileSystem` instead of `node:fs` in services
- `Path.Path` instead of direct path manipulation in services
- `HttpClient.HttpClient` for outbound HTTP
- platform-specific layers such as `NodeServices.layer`, `NodeHttpClient.layerUndici`, or `FetchHttpClient.layer` at the edge

Direct Node APIs are acceptable in very thin adapters, scripts, generated code, or where the platform service does not expose the needed primitive. Keep that boundary small.

## HttpApi

Use `HttpApi`, `HttpApiGroup`, and `HttpApiEndpoint` when defining typed API contracts.

```typescript
import { HttpApi, HttpApiEndpoint, HttpApiGroup, OpenApi } from "@effect/platform"
import { Schema } from "effect"

export class UsersApi extends HttpApiGroup.make("users")
    .add(
        HttpApiEndpoint.get("getUser", "/users/:id")
            .setPath(Schema.Struct({ id: UserIdFromString }))
            .addSuccess(User)
            .addError(UserNotFound),
    )
    .annotate(OpenApi.Title, "Users")
{}

export class Api extends HttpApi.make("api").add(UsersApi) {}
```

Keep schemas and typed errors at the endpoint boundary. Avoid anonymous payload shapes and generic HTTP errors.

## HttpClient

Use Effect HTTP client requests for outbound calls. Keep request construction, body encoding, status filtering, and response decoding visible.

```typescript
import { HttpClient, HttpClientRequest, HttpClientResponse } from "@effect/platform"
import { Effect, Schema } from "effect"

const ProviderResponse = Schema.Struct({
    id: Schema.String,
    status: Schema.String,
})

const sendProviderRequest = Effect.fn("Provider.sendRequest")(function* (payload: ProviderPayload) {
    const client = yield* HttpClient.HttpClient

    const response = yield* HttpClientRequest.post("/v1/messages").pipe(
        HttpClientRequest.bodyJson(payload),
        Effect.flatMap(client.execute),
        Effect.flatMap(HttpClientResponse.filterStatusOk),
        Effect.flatMap(HttpClientResponse.schemaBodyJson(ProviderResponse)),
    )

    return response
})
```

Prefer schema-backed request and response bodies. Add timeouts, retries, and status-specific error mapping at this boundary, not deep in domain code.

## Rpc

Use Effect Rpc when the app needs typed request/response or streaming contracts over transports such as WebSocket. Define payload, success, and error schemas at the RPC declaration.

Use the import path established by the package you are editing. Newer packages may import from `@effect/rpc`; packages using bundled unstable re-exports may import from `effect/unstable/rpc/*`.

```typescript
import { Rpc, RpcGroup } from "@effect/rpc"
import { Schema } from "effect"

export const GetSettings = Rpc.make("server.getSettings", {
    payload: {},
    success: Settings,
    error: SettingsReadError,
})

export class ServerRpc extends RpcGroup.make(GetSettings) {}
```

Implement handlers with `toLayer` and keep observability around each method.

```typescript
export const ServerRpcLive = ServerRpc.toLayer(
    Effect.gen(function* () {
        const settings = yield* SettingsService

        return ServerRpc.of({
            "server.getSettings": () =>
                settings.get.pipe(
                    Effect.withSpan("Rpc.server.getSettings"),
                ),
        })
    }),
)
```

Do not hand-roll JSON-RPC parsing when Effect Rpc is the chosen contract layer. If integrating with a non-Effect JSON-RPC process, keep the handwritten transport adapter small and schema-decode every inbound and outbound payload.

## Workflow

See `workflow-patterns.md` for durable workflow guidance, fit checks, activity boundaries, and testing notes.

## What To Check Before Adding A Module

- Is this module already used in the package?
- Is the contract schema-backed?
- Where is the platform/runtime layer provided?
- What errors cross the boundary?
- How will tests provide or mock the layer?
- Does the language service report warnings after the change?
