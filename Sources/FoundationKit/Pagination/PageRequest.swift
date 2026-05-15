import Foundation

public struct PageRequest: Codable, Equatable, Sendable {
    public let page: Int
    public let pageSize: Int

    public init(
        page: Int = 1,
        pageSize: Int = 20,
        maximumPageSize: Int = 100
    ) {
        let safeMaximum = max(1, maximumPageSize)
        self.page = max(1, page)
        self.pageSize = min(max(1, pageSize), safeMaximum)
    }

    public var offset: Int {
        (page - 1) * pageSize
    }
}

public struct Page<Item: Sendable>: Sendable {
    public let items: [Item]
    public let request: PageRequest
    public let totalCount: Int?
    public let hasMore: Bool

    public init(
        items: [Item],
        request: PageRequest,
        totalCount: Int? = nil,
        hasMore: Bool
    ) {
        self.items = items
        self.request = request
        self.totalCount = totalCount.map { max(0, $0) }
        self.hasMore = hasMore
    }
}

extension Page: Codable where Item: Codable {}

extension Page: Equatable where Item: Equatable {}
