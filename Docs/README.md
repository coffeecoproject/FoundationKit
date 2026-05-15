# FoundationKit Docs

FoundationKit is a small, app-neutral P0 foundation module. Start with the README, then use the documents below for integration and release work.

## Documents

1. [Architecture](Architecture.md): dependency direction, module areas, error boundary, and stability contract.
2. [Integration Guide](IntegrationGuide.md): practical usage patterns and migration checklist.
3. [API Reference](APIReference.md): public type and function overview.
4. [Semantic Versioning Policy](SemVerPolicy.md): compatibility and breaking-change rules.
5. [Release Readiness](ReleaseReadiness.md): release gate checklist.

## Boundary Summary

FoundationKit may depend on Swift `Foundation` only. It must not include UI, network transport, storage, Keychain, analytics, logging sinks, vendor SDKs, or app/business-specific vocabulary.
