import Foundation
import XCTest
@testable import FoundationKit

final class ConcurrencyTests: XCTestCase {
    func testWithTimeoutReturnsOperationResult() async throws {
        let value = try await withTimeout(seconds: 1) {
            "ok"
        }

        XCTAssertEqual(value, "ok")
    }

    func testWithTimeoutThrowsWhenExceeded() async throws {
        do {
            _ = try await withTimeout(seconds: 0.01) {
                try await Task.sleep(nanoseconds: 100_000_000)
                return "late"
            }
            XCTFail("Expected timeout")
        } catch let error as TaskTimeoutError {
            XCTAssertEqual(error, .exceeded(seconds: 0.01))
        }
    }

    func testRetryingRetriesUntilSuccess() async throws {
        let lock = AttemptCounter()
        let result = try await retrying(policy: .init(
            maxRetryCount: 2,
            initialDelaySeconds: 0,
            backoffMultiplier: 1,
            maximumDelaySeconds: 0
        ), shouldRetry: { _ in true }) {
            let attempt = await lock.next()
            if attempt < 3 {
                throw SampleError.transient
            }
            return "done"
        }

        XCTAssertEqual(result, "done")
        let attemptCount = await lock.value
        XCTAssertEqual(attemptCount, 3)
    }

    func testRetryingDoesNotRetryByDefault() async throws {
        let lock = AttemptCounter()

        do {
            _ = try await retrying {
                _ = await lock.next()
                throw SampleError.transient
            }
            XCTFail("Expected original error")
        } catch SampleError.transient {
            let attemptCount = await lock.value
            XCTAssertEqual(attemptCount, 1)
        }
    }

    func testWithTimeoutRejectsZeroSeconds() async throws {
        do {
            _ = try await withTimeout(seconds: 0) {
                "unused"
            }
            XCTFail("Expected invalid timeout")
        } catch let error as TaskTimeoutError {
            XCTAssertEqual(error, .invalidTimeout(seconds: 0))
        }
    }

    func testAsyncGateSkipsConcurrentWork() async throws {
        let gate = AsyncGate()
        let started = XCTestExpectation(description: "first operation started")
        let release = ReleaseGate()

        let first = Task {
            await gate.runIfIdle {
                started.fulfill()
                await release.wait()
            }
        }

        await fulfillment(of: [started], timeout: 1)

        let second = await gate.runIfIdle {}
        await release.release()
        let firstDecision = await first.value

        XCTAssertEqual(second, .skipped)
        XCTAssertEqual(firstDecision, .executed)
    }
}

private enum SampleError: Error {
    case transient
}

private actor AttemptCounter {
    private var count = 0

    var value: Int {
        count
    }

    func next() -> Int {
        count += 1
        return count
    }
}

private actor ReleaseGate {
    private var continuation: CheckedContinuation<Void, Never>?
    private var isReleased = false

    func wait() async {
        if isReleased {
            return
        }

        await withCheckedContinuation { continuation in
            self.continuation = continuation
        }
    }

    func release() {
        isReleased = true
        continuation?.resume()
        continuation = nil
    }
}
