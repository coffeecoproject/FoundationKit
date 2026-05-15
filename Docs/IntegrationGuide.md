# FoundationKit Integration Guide

## Recommended Placement

Use FoundationKit as the first dependency for app-neutral modules:

```text
FoundationKit
PlatformKit / InfrastructureKit
Domain modules
Feature modules
App shell
```

## Strong IDs

```swift
struct Account: Sendable {}
struct Activity: Sendable {}

let accountID: EntityID<Account> = .new()
let activityID: EntityID<Activity> = .new()
```

This prevents accidentally passing an activity ID where an account ID is expected.

## Clocks

Use `DateProviding` instead of calling `Date()` directly in domain logic that needs deterministic tests.

```swift
struct TokenExpiryChecker {
    let clock: DateProviding

    func isExpired(_ expiresAt: Date) -> Bool {
        expiresAt <= clock.now()
    }
}
```

## Use Cases

```swift
struct LoadProfileUseCase: AsyncUseCase {
    struct Input: Sendable {
        let id: EntityID<User>
    }

    func execute(_ input: Input) async throws -> Profile {
        try await repository.load(id: input.id)
    }
}
```

## Retry and Timeout

Keep retries limited to idempotent or explicitly safe operations. FoundationKit provides generic mechanics; the caller owns business safety.

```swift
let value = try await retrying(policy: .noRetry) {
    try await operation()
}
```

For real retries, opt in explicitly:

```swift
let value = try await retrying(
    policy: .default,
    shouldRetry: { error in
        (error as? FoundationFailure)?.recoverability == .retry
    }
) {
    try await idempotentOperation()
}
```

## Migration Checklist

1. Move only app-neutral primitives into FoundationKit.
2. Replace raw UUID strings with `EntityID<Owner>` where type safety matters.
3. Replace direct `Date()` in test-sensitive domain logic with `DateProviding`.
4. Keep network, database, Keychain, SDK, and UI code outside this module.
