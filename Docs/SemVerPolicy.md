# Semantic Versioning Policy

FoundationKit follows Semantic Versioning.

```text
MAJOR.MINOR.PATCH
```

## Patch Releases

Patch releases may include:

1. Bug fixes that do not change public API.
2. Documentation corrections.
3. Test-only improvements.
4. Internal implementation changes that preserve behavior.

Examples:

1. Fixing a timeout edge case without changing signatures.
2. Adding tests for existing behavior.
3. Clarifying README examples.

## Minor Releases

Minor releases may include backward-compatible additions:

1. New public types.
2. New enum cases when callers are expected to use non-exhaustive handling.
3. New methods, initializers, or convenience helpers.
4. New conditional conformances.
5. New documentation.

## Major Releases

Major releases are required for breaking changes:

1. Removing or renaming public types, functions, properties, enum cases, or files that are part of the public module API.
2. Changing Codable field names or encoded value semantics.
3. Changing raw string values for public failure codes or public enums.
4. Tightening generic constraints on public types.
5. Changing default behavior in a way that could affect callers, especially retry, timeout, ID, failure, and pagination behavior.
6. Raising minimum supported platform versions.

## Stability Rules

Public failure codes are stable API.

Public Codable shapes are stable API.

Default behavior must be conservative and fail-closed. Any change from fail-closed to more permissive behavior is breaking unless introduced behind a new explicit API.

## Deprecation Policy

Prefer deprecating before removing.

Recommended flow:

1. Add the replacement API.
2. Mark old API as deprecated in a minor release.
3. Remove old API in the next major release.
