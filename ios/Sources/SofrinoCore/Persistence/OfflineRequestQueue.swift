import Foundation

/// Conformance required for anything that can sit in an `OfflineRequestQueue`
/// — a durable, replayable description of a mutation (e.g. "upload this
/// trade license"), not the mutation itself. Keeping operations `Codable`
/// is what lets the queue survive an app relaunch: a chef who loses signal
/// mid-upload and force-quits the app still has that upload waiting when
/// they reopen it.
public protocol OfflineOperation: Codable, Sendable, Identifiable where ID == UUID {
    var createdAt: Date { get }
}

/// A durable FIFO queue of pending mutations, persisted to disk and drained
/// automatically when connectivity returns. This is the mechanism behind
/// the Design System's "offline-aware, not offline-first" principle: the
/// UI can let a chef tap "Upload" while offline, show it as pending, and
/// trust the queue to finish the job the moment signal returns.
///
/// Order is preserved and strictly FIFO: if draining an operation fails
/// with a retryable error, the queue stops rather than reordering, so
/// operations never complete out of sequence.
@MainActor
public final class OfflineRequestQueue<Operation: OfflineOperation> {
    public typealias Executor = (Operation) async throws -> Void

    private let cache: OfflineCaching
    private let cacheKey = "pending_operations"
    private let executor: Executor
    private let logger: SofrinoLogger

    public private(set) var pendingOperations: [Operation] = []

    public init(cache: OfflineCaching, logger: SofrinoLogger = .init(category: "offline-queue"), executor: @escaping Executor) {
        self.cache = cache
        self.logger = logger
        self.executor = executor
        self.pendingOperations = cache.load([Operation].self, forKey: cacheKey) ?? []
    }

    public func enqueue(_ operation: Operation) {
        pendingOperations.append(operation)
        persist()
    }

    /// Attempts every pending operation in order. Stops at the first
    /// retryable failure (leaving it and everything after it queued);
    /// silently drops operations that fail with a non-retryable error,
    /// since retrying those would never succeed.
    public func drain() async {
        guard !pendingOperations.isEmpty else { return }
        logger.info("Draining \(pendingOperations.count) pending operation(s)")

        var remaining = pendingOperations
        while let next = remaining.first {
            do {
                try await executor(next)
                remaining.removeFirst()
                pendingOperations = remaining
                persist()
            } catch let error as NetworkError where error.isRetryable {
                logger.info("Pausing drain — retryable failure for operation \(next.id)")
                return
            } catch {
                logger.error("Dropping unrecoverable operation \(next.id): \(error)")
                remaining.removeFirst()
                pendingOperations = remaining
                persist()
            }
        }
    }

    public func remove(_ id: Operation.ID) {
        pendingOperations.removeAll { $0.id == id }
        persist()
    }

    private func persist() {
        try? cache.save(pendingOperations, forKey: cacheKey)
    }
}
