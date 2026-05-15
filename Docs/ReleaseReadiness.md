# FoundationKit Release Readiness

Before releasing a version:

1. `swift test` passes.
2. Public API changes are reviewed as additive or explicitly breaking.
3. No imports beyond `Foundation` exist in `Sources/FoundationKit`.
4. No business vocabulary is introduced into public symbols.
5. No persistence, network, UI, analytics, or vendor SDK dependency is introduced.
6. README and integration examples match current API.
7. Changelog includes the release.
8. `Docs/APIReference.md` and `Docs/SemVerPolicy.md` are current when public API changes.
9. If repository CI is enabled, the same strict test and release build commands pass on `main`.

Suggested command:

```bash
cd FoundationKit
swift test
```
