import XCTest
@testable import SofrinoCore

final class MoneyTests: XCTestCase {
    func testFormattedShowsAEDPrefixAndTwoDecimals() {
        let money = Money(amount: 32.5)
        XCTAssertEqual(money.formatted, "AED 32.50")
    }

    func testFormattedRoundsToTwoDecimalsForWholeNumbers() {
        let money = Money(amount: 100)
        XCTAssertEqual(money.formatted, "AED 100.00")
    }

    func testFormattedUsesGroupingSeparatorForLargeAmounts() {
        let money = Money(amount: 12345.6)
        XCTAssertEqual(money.formatted, "AED 12,345.60")
    }

    func testAdditionIsExact() {
        // The classic float trap: 0.1 + 0.2 != 0.3 in Double. Decimal
        // must not repeat that mistake for prices that get summed in a cart.
        let a = Money(amount: 0.1)
        let b = Money(amount: 0.2)
        XCTAssertEqual((a + b).amount, Decimal(string: "0.3"))
    }

    func testMultiplicationByQuantity() {
        let unitPrice = Money(amount: 32.50)
        XCTAssertEqual((unitPrice * 3).amount, Decimal(string: "97.5"))
    }

    func testPercentageChangeDetectsIncrease() {
        let previous = Money(amount: 28.00)
        let current = Money(amount: 32.50)
        XCTAssertEqual(previous.percentageChange(to: current), 16)
    }

    func testPercentageChangeDetectsDecrease() {
        let previous = Money(amount: 82.00)
        let current = Money(amount: 76.50)
        XCTAssertEqual(previous.percentageChange(to: current), -7)
    }

    func testDecimalStringInitializerRejectsGarbage() {
        XCTAssertThrowsError(try Money(decimalString: "not a number"))
    }

    func testDecimalStringInitializerParsesValidAmount() throws {
        let money = try Money(decimalString: "45.99")
        XCTAssertEqual(money.formatted, "AED 45.99")
    }

    func testComparable() {
        XCTAssertTrue(Money(amount: 10) < Money(amount: 20))
        XCTAssertFalse(Money(amount: 20) < Money(amount: 10))
    }
}
