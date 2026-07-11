import Foundation
import SofrinoCore

// MARK: - PostgREST (/rest/v1/categories, /rest/v1/products) wire types
//
// `ProductDTO.supplier` relies on PostgREST's resource embedding —
// `select=*,supplier:suppliers(id,name,is_verified,rating,delivery_estimate)`
// — so a product fetch and its supplier summary arrive in one round trip
// rather than N+1 queries per product card.

struct CategoryDTO: Decodable {
    let id: String
    let name: String
    let iconSystemImage: String
    let tintHex: String
    let imageURL: URL?
}

struct SupplierSummaryDTO: Decodable {
    let id: String
    let name: String
    let isVerified: Bool
    let rating: Double?
    let deliveryEstimate: String?
}

struct ProductDTO: Decodable {
    let id: String
    let name: String
    let description: String
    let imageURL: URL?
    let price: Decimal
    let previousPrice: Decimal?
    let unit: String
    let minimumOrderQuantity: Int
    let supplier: SupplierSummaryDTO
    let categoryID: String
    let isFresh: Bool
    let isFrozen: Bool
    let rating: Double?
    let reviewCount: Int
}

// MARK: - Domain mapping

extension Category {
    init(dto: CategoryDTO) {
        self.init(id: dto.id, name: dto.name, iconSystemImage: dto.iconSystemImage, tintHex: dto.tintHex, imageURL: dto.imageURL)
    }
}

extension SupplierSummary {
    init(dto: SupplierSummaryDTO) {
        self.init(id: dto.id, name: dto.name, isVerified: dto.isVerified, rating: dto.rating, deliveryEstimate: dto.deliveryEstimate)
    }
}

extension Product {
    init(dto: ProductDTO) {
        self.init(
            id: dto.id,
            name: dto.name,
            description: dto.description,
            imageURL: dto.imageURL,
            price: Money(amount: dto.price),
            previousPrice: dto.previousPrice.map(Money.init(amount:)),
            unit: dto.unit,
            minimumOrderQuantity: dto.minimumOrderQuantity,
            supplier: SupplierSummary(dto: dto.supplier),
            categoryID: dto.categoryID,
            isFresh: dto.isFresh,
            isFrozen: dto.isFrozen,
            rating: dto.rating,
            reviewCount: dto.reviewCount
        )
    }
}
