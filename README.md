# FoundationKit

FoundationKit is a standalone Swift P0 foundation module for iOS and macOS apps.

FoundationKit 是一个独立的 Swift P0 基础模块，用于承载所有业务模块都可以安全依赖的最小公共能力。

## Scope / 能力范围

1. Strongly typed IDs: `EntityID<Owner>`, `UUIDGenerating`.
2. Time injection: `DateProviding`, `SystemDateProvider`, `FixedDateProvider`.
3. Concurrency boundaries: `AsyncUseCase`, `AsyncGate`, `withTimeout`, `retrying`, `TaskCancellation`.
4. Common protocols: `IdentifiedEntity`, `TimestampedEntity`, `VersionedEntity`.
5. Error primitives: `FoundationFailure`, stable codes, severity, recoverability.
6. Pagination primitives: `PageRequest`, `Page`, `CursorPageRequest`, `CursorPage`.
7. Operation state primitive: `OperationState`.

## Industrial Boundary / 工业边界

FoundationKit must stay small, stable, and app-neutral.

FoundationKit 必须保持“小、稳、无业务”。

Allowed:

1. Basic types and value wrappers.
2. ID/time/task/cancellation primitives.
3. Public protocols that do not encode business behavior.
4. Error primitives without presentation or routing policy.
5. Pagination and operation-state primitives.

Forbidden:

1. UI components, design tokens, SwiftUI/UIKit views.
2. Database clients, SQL, migrations, ORM code.
3. HTTP clients, auth refresh flows, upload vendors, SDK integrations.
4. Keychain, file storage, analytics, telemetry, push notification clients.
5. Business nouns such as UserService, OrderRepository, PaymentClient, ModelTrainingService.
6. App-specific configuration, secrets, feature flags, or routes.

## Installation / 安装

```swift
.package(url: "https://github.com/coffeecoproject/FoundationKit.git", from: "0.1.0")
```

Add `FoundationKit` to your target.

## Basic Usage / 基础用法

```swift
import FoundationKit

struct User: Sendable {}
struct Project: Sendable {}

let userID = EntityID<User>.new()
let projectID = EntityID<Project>.new()
```

`EntityID<User>` and `EntityID<Project>` are different Swift types even when their raw UUID values match.

## Testable Time / 可测试时间

```swift
struct SessionFactory {
    let clock: DateProviding

    func makeCreatedAt() -> Date {
        clock.now()
    }
}

let factory = SessionFactory(clock: FixedDateProvider(Date(timeIntervalSince1970: 1_800_000_000)))
```

## Task Boundary / 任务边界

```swift
let profile = try await withTimeout(seconds: 3) {
    try await loadProfile()
}

let result = try await retrying(
    policy: .default,
    shouldRetry: { error in
        (error as? FoundationFailure)?.recoverability == .retry
    }
) {
    try await fetchCachedSafeResource()
}
```

## Non-Goals / 非目标

FoundationKit intentionally does not include:

1. Error display policy. Use an error-governance module above it.
2. Network transport. Use a network module above it.
3. Storage or Keychain. Use infrastructure/platform modules above it.
4. UI state rendering. Keep UI in design system or presentation modules.
5. Business entities or repositories.

## Retry Contract / 重试契约

`retrying` is fail-closed by default: it does not retry unless the caller explicitly provides both a retry policy and a `shouldRetry` predicate. FoundationKit provides the mechanics; the caller owns idempotency and business safety.

## Documentation / 文档

1. [Architecture / 架构说明](Docs/Architecture.md)
2. [Integration Guide / 接入指南](Docs/IntegrationGuide.md)
3. [API Reference / API 参考](Docs/APIReference.md)
4. [Semantic Versioning Policy / 语义化版本策略](Docs/SemVerPolicy.md)
5. [Release Readiness / 发布审查](Docs/ReleaseReadiness.md)
6. [Changelog / 更新日志](CHANGELOG.md)
7. [Contributing / 贡献指南](CONTRIBUTING.md)
8. [Security Policy / 安全策略](SECURITY.md)
9. [Code of Conduct / 行为准则](CODE_OF_CONDUCT.md)
10. [License / 授权协议](LICENSE)
