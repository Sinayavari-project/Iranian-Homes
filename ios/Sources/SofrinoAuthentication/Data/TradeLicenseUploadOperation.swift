import Foundation
import SofrinoCore

/// A durable, replayable description of a trade license submission —
/// see `OfflineOperation`. `documentData` is stored inline; trade license
/// photos are small enough (a few hundred KB, JPEG-compressed by
/// `TradeLicenseUploadViewModel` before this operation is built) that
/// writing them into the same JSON cache file as the rest of the queue is
/// simpler and more robust than managing a second temp-file lifecycle.
struct TradeLicenseUploadOperation: OfflineOperation {
    let id: UUID
    let createdAt: Date
    let userID: String
    let number: String
    let expiresAt: Date
    let documentData: Data
}
