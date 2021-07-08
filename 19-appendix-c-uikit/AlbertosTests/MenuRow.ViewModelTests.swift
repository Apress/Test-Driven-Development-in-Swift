@testable import Albertos
import XCTest

class MenuRowViewModelTests: XCTestCase {

    func testWhenItemIsNotSpicyTextIsItemNameOnly() {
        let item = MenuItem.fixture(name: "name", spicy: false)
        let viewModel = MenuRowViewModel(item: item)
        XCTAssertEqual(viewModel.text, "name")
    }

    func testWhenItemIsSpicyTextIsItemNameWithChiliEmoji() {
        let item = MenuItem.fixture(name: "name", spicy: true)
        let viewModel = MenuRowViewModel(item: item)
        XCTAssertEqual(viewModel.text, "name 🔥")
    }
}
