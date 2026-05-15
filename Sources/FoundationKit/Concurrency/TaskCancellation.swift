import Foundation

public enum TaskCancellation {
    public static var isCancelled: Bool {
        Task.isCancelled
    }

    public static func check() throws {
        try Task.checkCancellation()
    }

    public static func sleep(seconds: TimeInterval) async throws {
        guard seconds.isFinite, seconds > 0 else {
            return
        }

        try Task.checkCancellation()
        try await Task.sleep(nanoseconds: nanoseconds(from: seconds))
    }

    static func nanoseconds(from seconds: TimeInterval) -> UInt64 {
        let raw = seconds * 1_000_000_000
        guard raw.isFinite, raw > 0 else {
            return 0
        }
        return UInt64(min(raw, Double(UInt64.max)))
    }
}
