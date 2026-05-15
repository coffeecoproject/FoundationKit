import Foundation

public struct RetryPolicy: Equatable, Sendable {
    public let maxRetryCount: Int
    public let initialDelaySeconds: TimeInterval
    public let backoffMultiplier: Double
    public let maximumDelaySeconds: TimeInterval

    public init(
        maxRetryCount: Int,
        initialDelaySeconds: TimeInterval,
        backoffMultiplier: Double,
        maximumDelaySeconds: TimeInterval
    ) {
        self.maxRetryCount = max(0, maxRetryCount)
        self.initialDelaySeconds = max(0, initialDelaySeconds.isFinite ? initialDelaySeconds : 0)
        self.backoffMultiplier = max(1, backoffMultiplier.isFinite ? backoffMultiplier : 1)
        self.maximumDelaySeconds = max(0, maximumDelaySeconds.isFinite ? maximumDelaySeconds : 0)
    }

    public static let `default` = RetryPolicy(
        maxRetryCount: 2,
        initialDelaySeconds: 0.25,
        backoffMultiplier: 2,
        maximumDelaySeconds: 5
    )

    public static let noRetry = RetryPolicy(
        maxRetryCount: 0,
        initialDelaySeconds: 0,
        backoffMultiplier: 1,
        maximumDelaySeconds: 0
    )

    public func delaySeconds(forRetryAttempt attempt: Int) -> TimeInterval {
        guard attempt > 0 else {
            return min(initialDelaySeconds, maximumDelaySeconds)
        }

        let multiplied = initialDelaySeconds * pow(backoffMultiplier, Double(attempt))
        return min(multiplied, maximumDelaySeconds)
    }
}

public func retrying<T: Sendable>(
    policy: RetryPolicy = .noRetry,
    shouldRetry: @escaping @Sendable (Error) -> Bool = { _ in false },
    operation: @escaping @Sendable () async throws -> T
) async throws -> T {
    var retryAttempt = 0

    while true {
        do {
            try Task.checkCancellation()
            return try await operation()
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            guard retryAttempt < policy.maxRetryCount, shouldRetry(error) else {
                throw error
            }

            try await TaskCancellation.sleep(seconds: policy.delaySeconds(forRetryAttempt: retryAttempt))
            retryAttempt += 1
        }
    }
}
