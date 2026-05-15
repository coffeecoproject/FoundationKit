import Foundation

public enum OperationState<Value: Sendable>: Sendable {
    case idle
    case running
    case succeeded(Value)
    case failed(FoundationFailure)

    public var isRunning: Bool {
        if case .running = self {
            return true
        }
        return false
    }
}

extension OperationState: Equatable where Value: Equatable {}
