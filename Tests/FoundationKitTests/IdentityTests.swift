import Foundation
import XCTest
@testable import FoundationKit

final class IdentityTests: XCTestCase {
    private struct User: Sendable {}
    private struct Project: Sendable {}

    func testEntityIDPreservesOwnerPhantomType() throws {
        let uuid = try XCTUnwrap(UUID(uuidString: "00000000-0000-0000-0000-000000000123"))
        let userID = EntityID<User>(uuid)
        let projectID = EntityID<Project>(uuid)

        XCTAssertEqual(userID.uuidString, "00000000-0000-0000-0000-000000000123")
        XCTAssertEqual(projectID.uuidString, userID.uuidString)
    }

    func testEntityIDCodableRoundTrip() throws {
        let uuid = try XCTUnwrap(UUID(uuidString: "00000000-0000-0000-0000-000000000456"))
        let original = EntityID<User>(uuid)

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(EntityID<User>.self, from: data)

        XCTAssertEqual(decoded, original)
    }

    func testStaticUUIDGeneratorIsDeterministic() throws {
        let uuid = try XCTUnwrap(UUID(uuidString: "00000000-0000-0000-0000-000000000789"))
        let generator = StaticUUIDGenerator(uuid)

        XCTAssertEqual(EntityID<User>.new(using: generator).rawValue, uuid)
    }
}
