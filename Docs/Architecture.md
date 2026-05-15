# FoundationKit Architecture

## Purpose

FoundationKit defines the bottom layer of an app module graph. It provides primitives that are useful across modules without forcing a dependency on UI, networking, storage, auth, analytics, or business domains.

## Dependency Rule

Allowed direction:

```text
App / Features / Domain / Platform / Infrastructure -> FoundationKit
FoundationKit -> Swift Foundation only
```

FoundationKit must not depend on:

1. SwiftUI or UIKit.
2. Network transports.
3. Database clients.
4. Keychain or storage.
5. Logging or telemetry frameworks.
6. Business modules.

## Module Areas

1. `Identity`: strongly typed IDs and UUID generation contracts.
2. `Time`: injectable date source.
3. `Concurrency`: task, retry, timeout, and duplicate-work boundaries.
4. `Protocols`: app-neutral entity contracts.
5. `Errors`: stable failure primitive without UI policy.
6. `Pagination`: offset and cursor pagination value types.
7. `State`: app-neutral operation state.

## Error Boundary

`FoundationFailure` is a primitive. It is not a full app error governance system.

Higher layers may map it into a richer error policy engine, but FoundationKit does not decide:

1. user-facing text;
2. retry button policy;
3. route transitions;
4. reporting sinks;
5. alert/toast/dialog presentation.

## Stability Contract

Public types should be additive-first. Removing cases, changing raw values, or changing Codable field names is a breaking change.
