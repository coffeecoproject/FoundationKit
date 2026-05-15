import Foundation
import XCTest
@testable import FoundationKit

final class UseCaseTests: XCTestCase {
    func testAsyncUseCaseCallAsFunction() async throws {
        let useCase = EchoUseCase()

        let output = try await useCase("hello")

        XCTAssertEqual(output, "hello")
    }
}

private struct EchoUseCase: AsyncUseCase {
    func execute(_ input: String) async throws -> String {
        input
    }
}
