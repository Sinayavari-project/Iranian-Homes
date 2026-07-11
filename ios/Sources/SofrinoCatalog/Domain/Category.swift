import Foundation

/// A top-level product category (Fresh Produce, Meat & Poultry, Dairy...),
/// managed on the Admin console's master catalog (BRD §8.1). `iconSystemImage`
/// is the SF Symbol fallback shown until `imageURL` (if any) loads —
/// `SofrinoCategoryTile` in the Design System already implements exactly
/// that fallback behavior.
///
/// Deliberately holds `tintHex` rather than a `Color` — domain models stay
/// free of SwiftUI/UIKit; the presentation layer converts via
/// `Color(hex:)` (`SofrinoDesignSystem/Foundations/Color+Hex.swift`) at the
/// point of display.
public struct Category: Codable, Equatable, Identifiable, Sendable {
    public let id: String
    public let name: String
    public let iconSystemImage: String
    public let tintHex: String
    public let imageURL: URL?

    public init(id: String, name: String, iconSystemImage: String, tintHex: String, imageURL: URL? = nil) {
        self.id = id
        self.name = name
        self.iconSystemImage = iconSystemImage
        self.tintHex = tintHex
        self.imageURL = imageURL
    }
}
