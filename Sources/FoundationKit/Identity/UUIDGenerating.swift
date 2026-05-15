import Foundation

public protocol UUIDGenerating: Sendable {
    func makeUUID() -> UUID
}

public struct SystemUUIDGenerator: UUIDGenerating {
    public init() {}

    public func makeUUID() -> UUID {
        UUID()
    }
}

public struct StaticUUIDGenerator: UUIDGenerating {
    private let uuid: UUID

    public init(_ uuid: UUID) {
        self.uuid = uuid
    }

    public func makeUUID() -> UUID {
        uuid
    }
}
