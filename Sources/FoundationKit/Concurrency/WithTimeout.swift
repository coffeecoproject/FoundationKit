import Foundation

public enum TaskTimeoutError: Error, Equatable, Sendable {
    case invalidTimeout(seconds: TimeInterval)
    case exceeded(seconds: TimeInterval)
    case missingResult
}

public func withTimeout<T: Sendable>(
    seconds: TimeInterval,
    operation: @escaping @Sendable () async throws -> T
) async throws -> T {
    guard seconds.isFinite, seconds > 0 else {
        throw TaskTimeoutError.invalidTimeout(seconds: seconds)
    }

    return try await withThrowingTaskGroup(of: T.self) { group in
        group.addTask {
            try await operation()
        }

        group.addTask {
            try await Task.sleep(nanoseconds: TaskCancellation.nanoseconds(from: seconds))
            throw TaskTimeoutError.exceeded(seconds: seconds)
        }

        do {
            guard let result = try await group.next() else {
                throw TaskTimeoutError.missingResult
            }
            group.cancelAll()
            return result
        } catch {
            group.cancelAll()
            throw error
        }
    }
}
