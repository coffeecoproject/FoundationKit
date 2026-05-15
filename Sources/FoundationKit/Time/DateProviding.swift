import Foundation

public protocol DateProviding: Sendable {
    func now() -> Date
}

public struct SystemDateProvider: DateProviding {
    public init() {}

    public func now() -> Date {
        Date()
    }
}

public struct FixedDateProvider: DateProviding {
    public let fixedDate: Date

    public init(_ fixedDate: Date) {
        self.fixedDate = fixedDate
    }

    public func now() -> Date {
        fixedDate
    }
}
