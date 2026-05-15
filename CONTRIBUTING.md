# Contributing

FoundationKit accepts only app-neutral foundation primitives.

Before adding a public type, confirm:

1. Multiple modules can use it without importing business meaning.
2. It does not require UI, network, database, storage, logging, analytics, auth, or vendor SDK dependencies.
3. It can be tested deterministically.
4. It has a focused unit test.
5. Public Codable/raw string values are treated as stable API.

Do not add compatibility branches for app-specific migrations. Keep those in the consuming app or a higher-level module.

## Pull Request Checklist

1. Public API changes are documented in `Docs/APIReference.md`.
2. Compatibility impact is evaluated against `Docs/SemVerPolicy.md`.
3. Tests cover new behavior.
4. `swift test -Xswiftc -strict-concurrency=complete -Xswiftc -warnings-as-errors` passes.
5. `swift build -c release -Xswiftc -strict-concurrency=complete -Xswiftc -warnings-as-errors` passes.
6. No imports beyond `Foundation` are introduced under `Sources/FoundationKit`.
