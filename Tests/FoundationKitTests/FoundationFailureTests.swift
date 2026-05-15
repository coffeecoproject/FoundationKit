import Foundation
import XCTest
@testable import FoundationKit

final class FoundationFailureTests: XCTestCase {
    func testFoundationFailureCodableRoundTrip() throws {
        let failure = FoundationFailure(
            code: FoundationFailureCode.validationFailed,
            domain: .validation,
            technicalReason: "value must not be empty",
            context: ["field": "name"]
        )

        let data = try JSONEncoder().encode(failure)
        let decoded = try JSONDecoder().decode(FoundationFailure.self, from: data)

        XCTAssertEqual(decoded, failure)
        XCTAssertEqual(decoded.errorDescription, FoundationFailureCode.validationFailed)
        XCTAssertFalse(decoded.localizedDescription.contains("value must not be empty"))
    }
}
