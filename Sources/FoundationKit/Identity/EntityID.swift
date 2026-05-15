import Foundation

public struct EntityID<Owner>: RawRepresentable, Hashable, Codable, Sendable, CustomStringConvertible {
    public let rawValue: UUID

    public init(rawValue: UUID) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: UUID) {
        self.rawValue = rawValue
    }

    public init?(uuidString: String) {
        guard let uuid = UUID(uuidString: uuidString.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            return nil
        }
        self.rawValue = uuid
    }

    public static func new() -> Self {
        Self(SystemUUIDGenerator().makeUUID())
    }

    public static func new<G: UUIDGenerating>(using generator: G) -> Self {
        Self(generator.makeUUID())
    }

    public var uuidString: String {
        rawValue.uuidString.lowercased()
    }

    public var description: String {
        uuidString
    }
}

extension EntityID: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.uuidString < rhs.uuidString
    }
}
