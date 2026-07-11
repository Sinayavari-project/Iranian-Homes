import Foundation
import SofrinoCore

/// A single supplier's SKU as a restaurant buyer sees it: what it costs,
/// how it's sold, and who's selling it. `previousPrice` backs the Home
/// Screen's Price Movements ticker and this feature's price-change badge;
/// it's `nil` until a supplier has changed the price at least once.
public struct Product: Codable, Equatable, Identifiable, Sendable {
    public let id: String
    public let name: String
    public let description: String
    public let imageURL: URL?
    public let price: Money
    public let previousPrice: Money?
    /// The unit a single `price` buys — "kg", "carton", "case of 12".
    public let unit: String
    public let minimumOrderQuantity: Int
    public let supplier: SupplierSummary
    public let categoryID: String
    public let isFresh: Bool
    public let isFrozen: Bool
    public let rating: Double?
    public let reviewCount: Int

    public init(
        id: String,
        name: String,
        description: String,
        imageURL: URL?,
        price: Money,
        previousPrice: Money? = nil,
        unit: String,
        minimumOrderQuantity: Int = 1,
        supplier: SupplierSummary,
        categoryID: String,
        isFresh: Bool = false,
        isFrozen: Bool = false,
        rating: Double? = nil,
        reviewCount: Int = 0
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.price = price
        self.previousPrice = previousPrice
        self.unit = unit
        self.minimumOrderQuantity = minimumOrderQuantity
        self.supplier = supplier
        self.categoryID = categoryID
        self.isFresh = isFresh
        self.isFrozen = isFrozen
        self.rating = rating
        self.reviewCount = reviewCount
    }

    /// Percentage price change vs. `previousPrice`, for the price-change
    /// badge (Home Screen §6 "The Ticker"). `nil` when there's no prior price.
    public var priceChangePercent: Int? {
        guard let previousPrice else { return nil }
        return previousPrice.percentageChange(to: price)
    }
}
