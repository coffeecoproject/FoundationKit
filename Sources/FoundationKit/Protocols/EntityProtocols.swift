import Foundation

public protocol IdentifiedEntity: Sendable {
    associatedtype ID: Hashable & Sendable

    var id: ID { get }
}

public protocol TimestampedEntity: Sendable {
    var createdAt: Date { get }
    var updatedAt: Date { get }
}

public protocol VersionedEntity: Sendable {
    var version: Int { get }
}
