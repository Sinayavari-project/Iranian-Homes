import XCTest
@testable import SofrinoAuthentication

final class UAEPhoneNumberTests: XCTestCase {
    func testAcceptsLocalFormatWithLeadingZero() {
        let phone = UAEPhoneNumber(rawInput: "0501234567")
        XCTAssertEqual(phone?.e164, "+971501234567")
    }

    func testAcceptsSpacedLocalFormat() {
        let phone = UAEPhoneNumber(rawInput: "050 123 4567")
        XCTAssertEqual(phone?.e164, "+971501234567")
    }

    func testAcceptsFullInternationalFormat() {
        let phone = UAEPhoneNumber(rawInput: "+971 50 123 4567")
        XCTAssertEqual(phone?.e164, "+971501234567")
    }

    func testAcceptsNumberWithoutLeadingZero() {
        let phone = UAEPhoneNumber(rawInput: "501234567")
        XCTAssertEqual(phone?.e164, "+971501234567")
    }

    func testRejectsNonMobilePrefix() {
        // Landlines start with 04, 02, etc., not 05.
        XCTAssertNil(UAEPhoneNumber(rawInput: "043334455"))
    }

    func testRejectsTooShortNumber() {
        XCTAssertNil(UAEPhoneNumber(rawInput: "05012345"))
    }

    func testRejectsTooLongNumber() {
        XCTAssertNil(UAEPhoneNumber(rawInput: "050123456789"))
    }

    func testRejectsEmptyInput() {
        XCTAssertNil(UAEPhoneNumber(rawInput: ""))
    }

    func testFormattedNationalGroupsDigits() {
        let phone = UAEPhoneNumber(rawInput: "0501234567")
        XCTAssertEqual(phone?.formattedNational, "50 123 4567")
    }
}
