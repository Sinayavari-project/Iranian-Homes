import Foundation
import os

/// A thin, category-scoped wrapper over `os.Logger`. Exists so every layer
/// logs through one call site (easy to redirect to a remote log sink later)
/// and so log statements read `logger.error(...)` rather than repeating
/// `Logger(subsystem:category:)` boilerplate in every file.
public struct SofrinoLogger: Sendable {
    private let logger: Logger

    public init(category: String, subsystem: String = "com.sofrino.app") {
        self.logger = Logger(subsystem: subsystem, category: category)
    }

    public func debug(_ message: String) {
        logger.debug("\(message, privacy: .public)")
    }

    public func info(_ message: String) {
        logger.info("\(message, privacy: .public)")
    }

    public func error(_ message: String) {
        logger.error("\(message, privacy: .public)")
    }
}
