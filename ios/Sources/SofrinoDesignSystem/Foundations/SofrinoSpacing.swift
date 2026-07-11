import CoreGraphics

/// Spacing scale from the Sofrino Design System (Section 2: Spacing).
/// A 4pt base unit — every value here is a multiple of 4.
public enum SofrinoSpacing {
    public static let space0: CGFloat = 0
    public static let space1: CGFloat = 2
    public static let space2: CGFloat = 4
    public static let space3: CGFloat = 6
    public static let space4: CGFloat = 8
    public static let space5: CGFloat = 12
    public static let space6: CGFloat = 16
    public static let space7: CGFloat = 20
    public static let space8: CGFloat = 24
    public static let space9: CGFloat = 32
    public static let space10: CGFloat = 40
    public static let space11: CGFloat = 48
    public static let space12: CGFloat = 64

    /// Default screen margin on iPhone (16pt).
    public static let screenMargin: CGFloat = 16
    /// Screen margin on larger devices (iPhone Max/Plus).
    public static let screenMarginLarge: CGFloat = 20
    /// Gutter between cards in a grid layout.
    public static let cardGridGutter: CGFloat = 12
    /// Maximum content width — content never stretches beyond this.
    public static let maxContentWidth: CGFloat = 428
}

/// Corner radius tokens used across cards, buttons, and inputs.
public enum SofrinoRadius {
    public static let xs: CGFloat = 6
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 10
    public static let lg: CGFloat = 12
    public static let xl: CGFloat = 14
    public static let xxl: CGFloat = 16
    public static let xxxl: CGFloat = 20
    /// Fully rounded — pills, circular buttons, badges.
    public static let full: CGFloat = 999
}
