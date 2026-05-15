import Foundation

public struct CursorPageRequest: Codable, Equatable, Sendable {
    public let cursor: String?
    public let limit: Int

    public init(
        cursor: String? = nil,
        limit: Int = 20,
        maximumLimit: Int = 100
    ) {
        let trimmedCursor = cursor?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.cursor = trimmedCursor?.isEmpty == true ? nil : trimmedCursor
        self.limit = min(max(1, limit), max(1, maximumLimit))
    }
}

public struct CursorPage<Item: Sendable>: Sendable {
    public let items: [Item]
    public let nextCursor: String?
    public let hasMore: Bool

    public init(
        items: [Item],
        nextCursor: String?,
        hasMore: Bool
    ) {
        let trimmedCursor = nextCursor?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.items = items
        self.nextCursor = trimmedCursor?.isEmpty == true ? nil : trimmedCursor
        self.hasMore = hasMore
    }
}

extension CursorPage: Codable where Item: Codable {}

extension CursorPage: Equatable where Item: Equatable {}
