@testable import Albertos
import XCTest

class MenuItemDetailViewModelTests: XCTestCase {

    func testNameIsItemName() {
        XCTAssertEqual(
            MenuItemDetail.ViewModel(item: .fixture(name: "a name")).name,
            "a name"
        )
    }

    func testWhenItemIsSpicyShowsSpicyMessage() {
        XCTAssertEqual(
            MenuItemDetail.ViewModel(item: .fixture(spicy: true)).spicy,
            "Spicy"
        )
    }

    func testWhenItemIsNotSpicyDoesNotShowSpicyMessage() {
        XCTAssertNil(MenuItemDetail.ViewModel(item: .fixture(spicy: false)).spicy)
    }

    func testPriceIsFormattedItemPrice() {
        XCTAssertEqual(
            MenuItemDetail.ViewModel(item: .fixture(price: 1.0)).price,
            "$1.00"
        )
        XCTAssertEqual(
            MenuItemDetail.ViewModel(item: .fixture(price: 2.5)).price,
            "$2.50"
        )
        XCTAssertEqual(
            MenuItemDetail.ViewModel(item: .fixture(price: 3.45)).price,
            "$3.45"
        )
        XCTAssertEqual(
            MenuItemDetail.ViewModel(item: .fixture(price: 4.123)).price,
            "$4.12"
        )
    }
}
