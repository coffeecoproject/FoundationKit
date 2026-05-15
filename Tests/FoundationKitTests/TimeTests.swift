import Foundation
import XCTest
@testable import FoundationKit

final class TimeTests: XCTestCase {
    func testFixedDateProviderReturnsInjectedDate() throws {
        let date = Date(timeIntervalSince1970: 1_800_000_000)
        let provider = FixedDateProvider(date)

        XCTAssertEqual(provider.now(), date)
    }
}
