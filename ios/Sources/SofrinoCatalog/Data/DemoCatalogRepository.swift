import Foundation
import SofrinoCore

/// The investor demo `CatalogRepository` — curated, realistic UAE fixtures
/// so a pitch always shows a full, believable marketplace (BRD §1, §11).
/// Supplier and product names match the ones used as examples throughout
/// `docs/sofrino-home-screen.md`, so a demo walkthrough feels internally
/// consistent with the specs rather than showing "Lorem Ipsum" data.
public actor DemoCatalogRepository: CatalogRepository {
    private let artificialLatency: Duration

    public init(artificialLatency: Duration = .milliseconds(400)) {
        self.artificialLatency = artificialLatency
    }

    public func fetchCategories() async throws -> [Category] {
        try await Task.sleep(for: artificialLatency)
        return Self.categories
    }

    public func fetchProducts(query: ProductQuery) async throws -> ProductPage {
        try await Task.sleep(for: artificialLatency)

        var results = Self.products
        if let categoryID = query.categoryID {
            results = results.filter { $0.categoryID == categoryID }
        }
        if let searchText = query.searchText, !searchText.isEmpty {
            let needle = searchText.lowercased()
            results = results.filter {
                $0.name.lowercased().contains(needle) || $0.description.lowercased().contains(needle)
            }
        }

        guard query.offset < results.count else {
            return .empty
        }
        let end = min(query.offset + query.limit, results.count)
        let page = Array(results[query.offset..<end])
        return ProductPage(items: page, hasMore: end < results.count)
    }

    public func fetchProduct(id: String) async throws -> Product {
        try await Task.sleep(for: artificialLatency)
        guard let product = Self.products.first(where: { $0.id == id }) else {
            throw CatalogError.productNotFound
        }
        return product
    }

    public func cachedCategories() -> [Category] {
        // The demo is always instant and always local — there's no
        // "stale" state to distinguish from "fresh," so the cached read
        // and the network read return the same seed data.
        Self.categories
    }

    public func cachedProduct(id: String) -> Product? {
        Self.products.first(where: { $0.id == id })
    }

    // MARK: - Fixtures

    private static let categories: [Category] = [
        Category(id: "cat-produce", name: "Fresh Produce", iconSystemImage: "leaf.fill", tintHex: "#10B981"),
        Category(id: "cat-meat", name: "Meat & Poultry", iconSystemImage: "fork.knife", tintHex: "#DC2626"),
        Category(id: "cat-seafood", name: "Seafood", iconSystemImage: "water.waves", tintHex: "#06B6D4"),
        Category(id: "cat-dairy", name: "Dairy", iconSystemImage: "drop.fill", tintHex: "#3B82F6"),
        Category(id: "cat-frozen", name: "Frozen", iconSystemImage: "snowflake", tintHex: "#22D3EE"),
        Category(id: "cat-bakery", name: "Bakery", iconSystemImage: "birthday.cake.fill", tintHex: "#F59E0B"),
        Category(id: "cat-beverages", name: "Beverages", iconSystemImage: "cup.and.saucer.fill", tintHex: "#7C3AED"),
        Category(id: "cat-pantry", name: "Pantry & Spices", iconSystemImage: "takeoutbag.and.cup.and.straw.fill", tintHex: "#B45309")
    ]

    private static let alMadina = SupplierSummary(id: "sup-al-madina", name: "Al Madina Foods", isVerified: true, rating: 4.8, deliveryEstimate: "Next-day delivery")
    private static let emiratesDairy = SupplierSummary(id: "sup-emirates-dairy", name: "Emirates Dairy", isVerified: true, rating: 4.6, deliveryEstimate: "Next-day delivery")
    private static let nordicSeafood = SupplierSummary(id: "sup-nordic-seafood", name: "Nordic Seafood Co.", isVerified: true, rating: 4.9, deliveryEstimate: "2-day delivery")
    private static let gulfGrains = SupplierSummary(id: "sup-gulf-grains", name: "Gulf Grains Trading", isVerified: false, rating: 4.3, deliveryEstimate: "Next-day delivery")
    private static let barakahBakery = SupplierSummary(id: "sup-barakah-bakery", name: "Barakah Bakery Supplies", isVerified: true, rating: 4.7, deliveryEstimate: "Same-day delivery")

    private static let products: [Product] = [
        Product(
            id: "prod-chicken-breast",
            name: "Chicken Breast",
            description: "Fresh, hormone-free chicken breast, trimmed and ready for prep. Sourced daily from certified farms across the UAE.",
            imageURL: nil,
            price: Money(amount: 32.50),
            previousPrice: Money(amount: 28.00),
            unit: "kg",
            minimumOrderQuantity: 5,
            supplier: alMadina,
            categoryID: "cat-meat",
            isFresh: true,
            rating: 4.7,
            reviewCount: 214
        ),
        Product(
            id: "prod-lamb-shoulder",
            name: "Lamb Shoulder, Bone-In",
            description: "Premium lamb shoulder, ideal for slow roasting and traditional Emirati dishes.",
            imageURL: nil,
            price: Money(amount: 54.00),
            unit: "kg",
            minimumOrderQuantity: 3,
            supplier: alMadina,
            categoryID: "cat-meat",
            isFresh: true,
            rating: 4.6,
            reviewCount: 98
        ),
        Product(
            id: "prod-salmon",
            name: "Wild-Caught Norwegian Salmon",
            description: "Sustainably wild-caught salmon, flash-frozen at sea to lock in freshness. Skin-on fillets.",
            imageURL: nil,
            price: Money(amount: 89.00),
            unit: "kg",
            minimumOrderQuantity: 2,
            supplier: nordicSeafood,
            categoryID: "cat-seafood",
            isFrozen: true,
            rating: 4.9,
            reviewCount: 156
        ),
        Product(
            id: "prod-shrimp",
            name: "Jumbo Shrimp, Peeled & Deveined",
            description: "Large jumbo shrimp, cleaned and ready to cook. Individually quick-frozen.",
            imageURL: nil,
            price: Money(amount: 76.50),
            previousPrice: Money(amount: 82.00),
            unit: "kg",
            minimumOrderQuantity: 2,
            supplier: nordicSeafood,
            categoryID: "cat-seafood",
            isFrozen: true,
            rating: 4.8,
            reviewCount: 87
        ),
        Product(
            id: "prod-milk",
            name: "Full Cream Fresh Milk",
            description: "Pasteurized full cream milk, delivered chilled daily.",
            imageURL: nil,
            price: Money(amount: 6.25),
            unit: "liter",
            minimumOrderQuantity: 12,
            supplier: emiratesDairy,
            categoryID: "cat-dairy",
            isFresh: true,
            rating: 4.5,
            reviewCount: 301
        ),
        Product(
            id: "prod-labneh",
            name: "Labneh, Bulk 5kg",
            description: "Traditional strained yogurt cheese, made fresh weekly.",
            imageURL: nil,
            price: Money(amount: 42.00),
            unit: "tub",
            minimumOrderQuantity: 1,
            supplier: emiratesDairy,
            categoryID: "cat-dairy",
            isFresh: true,
            rating: 4.7,
            reviewCount: 64
        ),
        Product(
            id: "prod-rice",
            name: "Basmati Rice, 5kg",
            description: "Premium aged basmati rice, extra-long grain.",
            imageURL: nil,
            price: Money(amount: 48.00),
            unit: "bag",
            minimumOrderQuantity: 4,
            supplier: gulfGrains,
            categoryID: "cat-pantry",
            rating: 4.4,
            reviewCount: 178
        ),
        Product(
            id: "prod-spice-mix",
            name: "Baharat Spice Blend, 1kg",
            description: "House-blend Emirati baharat, ground fresh in small batches.",
            imageURL: nil,
            price: Money(amount: 38.00),
            unit: "bag",
            minimumOrderQuantity: 2,
            supplier: gulfGrains,
            categoryID: "cat-pantry",
            rating: 4.6,
            reviewCount: 52
        ),
        Product(
            id: "prod-pita",
            name: "Fresh Pita Bread, Case of 100",
            description: "Soft pocket pita, baked fresh every morning and delivered same-day.",
            imageURL: nil,
            price: Money(amount: 55.00),
            unit: "case",
            minimumOrderQuantity: 1,
            supplier: barakahBakery,
            categoryID: "cat-bakery",
            isFresh: true,
            rating: 4.8,
            reviewCount: 143
        ),
        Product(
            id: "prod-croissant",
            name: "Butter Croissants, Case of 48",
            description: "Frozen par-baked butter croissants — proof and bake fresh in your kitchen.",
            imageURL: nil,
            price: Money(amount: 96.00),
            unit: "case",
            minimumOrderQuantity: 1,
            supplier: barakahBakery,
            categoryID: "cat-bakery",
            isFrozen: true,
            rating: 4.5,
            reviewCount: 39
        )
    ]
}
