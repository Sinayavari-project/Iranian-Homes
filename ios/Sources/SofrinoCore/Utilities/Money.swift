import Foundation

/// A currency amount backed by `Decimal`, never `Double` — procurement
/// prices get summed, multiplied by quantity, and compared for BNPL credit
/// limits (BRD §7), and binary floating point silently accumulates error
/// under exactly those operations. `Decimal` doesn't.
///
/// Sofrino is UAE-only at launch (BRD §8.2 — "multi-country expansion" is
/// explicitly out of scope for V1), so this type is intentionally AED-only
/// rather than a general multi-currency abstraction; a currency code field
/// would be unused complexity until there's a second currency to support.
public struct Money: Codable, Equatable, Comparable, Hashable, Sendable {
    public let amount: Decimal

    public init(amount: Decimal) {
        self.amount = amount
    }

    public init(decimalString: String) throws {
        guard let decimal = Decimal(string: decimalString) else {
            throw MoneyError.invalidAmount(decimalString)
        }
        self.amount = decimal
    }

    public static let zero = Money(amount: 0)

    public static func < (lhs: Money, rhs: Money) -> Bool {
        lhs.amount < rhs.amount
    }

    public static func + (lhs: Money, rhs: Money) -> Money {
        Money(amount: lhs.amount + rhs.amount)
    }

    public static func * (lhs: Money, rhs: Int) -> Money {
        Money(amount: lhs.amount * Decimal(rhs))
    }

    /// Percentage change from `self` to `other`, rounded to whole percent —
    /// what the home screen's Price Movements ticker and product detail
    /// price history display (Home Screen §6).
    public func percentageChange(to other: Money) -> Int {
        guard amount != 0 else { return 0 }
        let change = (other.amount - amount) / amount * 100
        // `.intValue` truncates toward zero (16.9% -> 16), which
        // systematically understates the change shown to the buyer.
        // Round to the nearest whole percent instead.
        return Int(NSDecimalNumber(decimal: change).doubleValue.rounded())
    }

    /// "AED 32.50" — the exact format used throughout the Design System's
    /// mono price tokens. Always two fraction digits, always the "AED"
    /// prefix, regardless of device locale — prices are a UAE-market
    /// constant, not something that should localize into "$32.50" for a
    /// device set to US English.
    public var formatted: String {
        let formatter = Money.formatter
        return "AED " + (formatter.string(from: amount as NSDecimalNumber) ?? "\(amount)")
    }

    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_US_POSIX") // Fixed grouping/decimal separators, independent of device locale.
        return formatter
    }()
}

public enum MoneyError: Error, Equatable, Sendable {
    case invalidAmount(String)
}
