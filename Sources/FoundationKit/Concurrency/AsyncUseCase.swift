import Foundation

public struct EmptyUseCaseInput: Equatable, Sendable {
    public init() {}
}

public protocol AsyncUseCase: Sendable {
    associatedtype Input: Sendable
    associatedtype Output: Sendable

    func execute(_ input: Input) async throws -> Output
}

public extension AsyncUseCase {
    func callAsFunction(_ input: Input) async throws -> Output {
        try await execute(input)
    }
}
