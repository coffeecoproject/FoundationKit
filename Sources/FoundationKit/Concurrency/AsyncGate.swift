import Foundation

public actor AsyncGate {
    public enum Decision: Equatable, Sendable {
        case executed
        case skipped
    }

    private var isRunning = false

    public init() {}

    public func runIfIdle(
        _ operation: @escaping @Sendable () async -> Void
    ) async -> Decision {
        guard !isRunning else {
            return .skipped
        }

        isRunning = true
        defer { isRunning = false }

        await operation()
        return .executed
    }

    public func runThrowingIfIdle<T: Sendable>(
        _ operation: @escaping @Sendable () async throws -> T
    ) async throws -> T? {
        guard !isRunning else {
            return nil
        }

        isRunning = true
        defer { isRunning = false }

        return try await operation()
    }
}
