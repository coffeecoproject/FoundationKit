import Foundation
import XCTest
@testable import FoundationKit

final class PaginationTests: XCTestCase {
    func testPageRequestClampsBounds() {
        let request = PageRequest(page: -3, pageSize: 500, maximumPageSize: 50)

        XCTAssertEqual(request.page, 1)
        XCTAssertEqual(request.pageSize, 50)
        XCTAssertEqual(request.offset, 0)
    }

    func testCursorPageRequestNormalizesEmptyCursor() {
        let request = CursorPageRequest(cursor: "   ", limit: -10, maximumLimit: 30)

        XCTAssertNil(request.cursor)
        XCTAssertEqual(request.limit, 1)
    }

    func testPageSupportsNonCodableItems() {
        let page = Page(
            items: [NonCodableItem(id: "local-projection")],
            request: PageRequest(),
            hasMore: false
        )

        XCTAssertEqual(page.items.first?.id, "local-projection")
    }
}

private struct NonCodableItem: Equatable, Sendable {
    let id: String
}
