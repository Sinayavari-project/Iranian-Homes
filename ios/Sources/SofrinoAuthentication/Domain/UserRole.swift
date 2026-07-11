import SwiftUI
import SofrinoDesignSystem

/// The three roles defined in the Sofrino BRD §8.1 scope: "Three-role
/// platform: Restaurant, Supplier, Admin." Admin accounts are provisioned
/// internally by Sofrino ops and never go through self-service role
/// selection, so it's intentionally absent from `RoleSelectionView`.
public enum UserRole: String, Codable, CaseIterable, Sendable {
    case restaurant
    case supplier
    case admin

    public var displayName: String {
        switch self {
        case .restaurant: return "Restaurant"
        case .supplier: return "Supplier"
        case .admin: return "Admin"
        }
    }

    public var subtitle: String {
        switch self {
        case .restaurant: return "I buy supplies for my kitchen"
        case .supplier: return "I sell to restaurants"
        case .admin: return "Sofrino internal team"
        }
    }

    public var systemImage: String {
        switch self {
        case .restaurant: return "fork.knife"
        case .supplier: return "shippingbox.fill"
        case .admin: return "shield.fill"
        }
    }

    /// Roles a new user may self-select during onboarding.
    public static var selectable: [UserRole] { [.restaurant, .supplier] }
}
