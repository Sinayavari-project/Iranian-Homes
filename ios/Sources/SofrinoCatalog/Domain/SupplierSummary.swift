import Foundation

/// The slice of a supplier's profile shown while browsing products — a
/// name, a trust signal, a delivery promise. A full supplier profile
/// (banner, category tags, order history, reviews — Home Screen §9 "The
/// Deck") belongs to a future Supplier Directory feature; embedding that
/// entire model here would give Catalog a dependency it doesn't need for
/// "whose product is this."
public struct SupplierSummary: Codable, Equatable, Identifiable, Sendable {
    public let id: String
    public let name: String
    public let isVerified: Bool
    public let rating: Double?
    public let deliveryEstimate: String?

    public init(id: String, name: String, isVerified: Bool, rating: Double? = nil, deliveryEstimate: String? = nil) {
        self.id = id
        self.name = name
        self.isVerified = isVerified
        self.rating = rating
        self.deliveryEstimate = deliveryEstimate
    }
}
