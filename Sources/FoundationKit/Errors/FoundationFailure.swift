import Foundation

public enum FoundationFailureDomain: String, Codable, CaseIterable, Sendable {
    case identity
    case time
    case concurrency
    case pagination
    case validation
    case unknown
}

public enum FoundationFailureSeverity: String, Codable, CaseIterable, Sendable {
    case info
    case warning
    case critical
}

public enum FoundationFailureRecoverability: String, Codable, CaseIterable, Sendable {
    case none
    case retry
    case callerAction = "caller_action"
}

public struct FoundationFailure: Error, LocalizedError, Codable, Equatable, Sendable {
    public let code: String
    public let domain: FoundationFailureDomain
    public let severity: FoundationFailureSeverity
    public let recoverability: FoundationFailureRecoverability
    public let technicalReason: String
    public let context: [String: String]

    public init(
        code: String,
        domain: FoundationFailureDomain,
        severity: FoundationFailureSeverity = .warning,
        recoverability: FoundationFailureRecoverability = .callerAction,
        technicalReason: String,
        context: [String: String] = [:]
    ) {
        self.code = code
        self.domain = domain
        self.severity = severity
        self.recoverability = recoverability
        self.technicalReason = technicalReason
        self.context = context
    }

    public var errorDescription: String? {
        code
    }
}

public enum FoundationFailureCode {
    public static let invalidIdentifier = "foundation.identity.invalid_identifier"
    public static let invalidTimeout = "foundation.concurrency.invalid_timeout"
    public static let timeoutExceeded = "foundation.concurrency.timeout_exceeded"
    public static let invalidPageRequest = "foundation.pagination.invalid_page_request"
    public static let validationFailed = "foundation.validation.failed"
    public static let unknown = "foundation.unknown"
}
