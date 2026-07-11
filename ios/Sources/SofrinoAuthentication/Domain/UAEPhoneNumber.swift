import Foundation

/// Validates and formats UAE mobile numbers. Centralized here so the
/// validation rule used by `PhoneEntryViewModel` (inline field validation)
/// and the E.164 conversion used by `SupabaseAuthRepository` (wire format)
/// can never drift apart.
///
/// UAE mobile numbers: local format `05X XXX XXXX` (10 digits starting
/// with `05`), second digit 0-9 denoting carrier. E.164: `+9715XXXXXXXX`.
public struct UAEPhoneNumber: Equatable, Sendable {
    /// E.164 format, e.g. "+971501234567".
    public let e164: String

    public init?(rawInput: String) {
        let digitsOnly = rawInput.filter(\.isNumber)

        let nationalDigits: String
        if digitsOnly.hasPrefix("971") {
            nationalDigits = String(digitsOnly.dropFirst(3))
        } else if digitsOnly.hasPrefix("0") {
            nationalDigits = String(digitsOnly.dropFirst())
        } else {
            nationalDigits = digitsOnly
        }

        // UAE mobile: 9 digits after the leading 0/country code, starting with 5.
        guard nationalDigits.count == 9, nationalDigits.hasPrefix("5") else {
            return nil
        }

        self.e164 = "+971" + nationalDigits
    }

    /// Formats as a national-style display string: "50 123 4567".
    public var formattedNational: String {
        let national = e164.dropFirst(4) // drop "+971"
        guard national.count == 9 else { return String(national) }
        let first = national.prefix(2)
        let middle = national.dropFirst(2).prefix(3)
        let last = national.suffix(4)
        return "\(first) \(middle) \(last)"
    }
}
