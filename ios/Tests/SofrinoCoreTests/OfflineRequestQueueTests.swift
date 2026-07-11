import XCTest
@testable import SofrinoCore

private struct TestOperation: OfflineOperation, Equatable {
    let id: UUID
    let createdAt: Date
    let payload: String
}

final class InMemoryOfflineCache: OfflineCaching, @unchecked Sendable {
    private var storage: [String: Data] = [:]

    func save<T: Encodable>(_ value: T, forKey key: String) throws {
        storage[key] = try JSONEncoder.sofrinoDefault.encode(value)
    }

    func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = storage[key] else { return nil }
        return try? JSONDecoder.sofrinoDefault.decode(T.self, from: data)
    }

    func remove(forKey key: String) { storage.removeValue(forKey: key) }
    func clear() { storage.removeAll() }
}

@MainActor
final class OfflineRequestQueueTests: XCTestCase {
    func testEnqueuePersistsOperation() {
        let cache = InMemoryOfflineCache()
        let queue = OfflineRequestQueue<TestOperation>(cache: cache) { _ in }

        let operation = TestOperation(id: UUID(), createdAt: Date(), payload: "a")
        queue.enqueue(operation)

        XCTAssertEqual(queue.pendingOperations, [operation])

        // A freshly constructed queue against the same cache should
        // rehydrate the pending operation — this is what makes the queue
        // survive an app relaunch.
        let reloaded = OfflineRequestQueue<TestOperation>(cache: cache) { _ in }
        XCTAssertEqual(reloaded.pendingOperations, [operation])
    }

    func testDrainRemovesSuccessfulOperationsInOrder() async {
        let cache = InMemoryOfflineCache()
        var executed: [String] = []
        let queue = OfflineRequestQueue<TestOperation>(cache: cache) { operation in
            executed.append(operation.payload)
        }

        queue.enqueue(TestOperation(id: UUID(), createdAt: Date(), payload: "first"))
        queue.enqueue(TestOperation(id: UUID(), createdAt: Date(), payload: "second"))

        await queue.drain()

        XCTAssertEqual(executed, ["first", "second"])
        XCTAssertTrue(queue.pendingOperations.isEmpty)
    }

    func testDrainStopsAtFirstRetryableFailure() async {
        let cache = InMemoryOfflineCache()
        var attempts = 0
        let queue = OfflineRequestQueue<TestOperation>(cache: cache) { operation in
            attempts += 1
            if operation.payload == "fails" {
                throw NetworkError.offline
            }
        }

        queue.enqueue(TestOperation(id: UUID(), createdAt: Date(), payload: "fails"))
        queue.enqueue(TestOperation(id: UUID(), createdAt: Date(), payload: "never reached"))

        await queue.drain()

        XCTAssertEqual(attempts, 1)
        XCTAssertEqual(queue.pendingOperations.count, 2, "Both operations should remain queued in order")
    }

    func testDrainDropsNonRetryableFailure() async {
        let cache = InMemoryOfflineCache()
        let queue = OfflineRequestQueue<TestOperation>(cache: cache) { operation in
            throw NetworkError.unauthorized
        }

        queue.enqueue(TestOperation(id: UUID(), createdAt: Date(), payload: "bad"))
        await queue.drain()

        XCTAssertTrue(queue.pendingOperations.isEmpty, "Non-retryable failures should be dropped, not retried forever")
    }
}
