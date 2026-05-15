# Security Policy

FoundationKit does not collect, store, transmit, or log user data.

Security expectations:

1. Do not add token, cookie, credential, or secret storage.
2. Do not add logging sinks.
3. Do not add network transport.
4. Do not add device identifier collection.
5. Do not add platform permission APIs.

If a future change needs one of those capabilities, it belongs in a higher-level Platform or Infrastructure module, not FoundationKit.
