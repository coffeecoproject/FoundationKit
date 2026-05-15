# FoundationKit API Reference

This document is a high-level reference for public API. It is intentionally concise; source files remain the executable contract.

## Module Metadata

### `FoundationKit`

Static module metadata.

```swift
FoundationKit.moduleName
FoundationKit.version
```

## Identity

### `EntityID<Owner>`

A strongly typed UUID wrapper using `Owner` as a phantom type.

Conforms to:

```text
RawRepresentable
Hashable
Codable
Sendable
CustomStringConvertible
Comparable
```

Common usage:

```swift
struct User: Sendable {}
let id = EntityID<User>.new()
```

### `UUIDGenerating`

Protocol for injectable UUID generation.

Implementations:

1. `SystemUUIDGenerator`
2. `StaticUUIDGenerator`

## Time

### `DateProviding`

Protocol for injectable time.

Implementations:

1. `SystemDateProvider`
2. `FixedDateProvider`

## Concurrency

### `AsyncUseCase`

App-neutral async use-case protocol.

```swift
public protocol AsyncUseCase: Sendable {
    associatedtype Input: Sendable
    associatedtype Output: Sendable

    func execute(_ input: Input) async throws -> Output
}
```

### `EmptyUseCaseInput`

Empty input value for no-argument use cases.

### `AsyncGate`

Actor that prevents duplicate concurrent work.

Methods:

1. `runIfIdle(_:)`
2. `runThrowingIfIdle(_:)`

### `RetryPolicy`

Generic retry timing policy. Retrying is fail-closed by default; `retrying` does not retry unless the caller explicitly provides a policy and `shouldRetry` predicate.

Static values:

1. `.default`
2. `.noRetry`

### `retrying(policy:shouldRetry:operation:)`

Runs an async operation with caller-approved retry behavior.

The caller owns idempotency and business safety.

### `TaskCancellation`

Small namespace for cancellation checks and sleep.

### `withTimeout(seconds:operation:)`

Runs an async operation with a positive timeout.

### `TaskTimeoutError`

Timeout error enum:

1. `invalidTimeout(seconds:)`
2. `exceeded(seconds:)`
3. `missingResult`

## Protocols

### `IdentifiedEntity`

Requires an app-defined `id`.

### `TimestampedEntity`

Requires `createdAt` and `updatedAt`.

### `VersionedEntity`

Requires integer `version`.

## Errors

### `FoundationFailure`

Codable, Sendable foundation-level failure primitive.

Fields:

1. `code`
2. `domain`
3. `severity`
4. `recoverability`
5. `technicalReason`
6. `context`

`localizedDescription` resolves to `code`, not `technicalReason`, to avoid accidental user-facing leakage.

### `FoundationFailureCode`

Stable string constants for foundation failure codes.

## Pagination

### `PageRequest`

Offset pagination request with clamped page and page size.

### `Page<Item>`

Offset pagination result. Requires only `Item: Sendable`; `Codable` and `Equatable` are conditional conformances.

### `CursorPageRequest`

Cursor pagination request with normalized cursor and clamped limit.

### `CursorPage<Item>`

Cursor pagination result. Requires only `Item: Sendable`; `Codable` and `Equatable` are conditional conformances.

## State

### `OperationState<Value>`

App-neutral operation state:

1. `idle`
2. `running`
3. `succeeded(Value)`
4. `failed(FoundationFailure)`
