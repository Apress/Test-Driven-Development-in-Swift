@testable import Albertos
import Nimble
import XCTest

class MenuRowViewModelTests: XCTestCase {

    func testWhenItemIsNotSpicyTextIsItemNameOnly() {
        let item = MenuItem.fixture(name: "name", spicy: false)
        let viewModel = MenuRow.ViewModel(item: item)
        expect(viewModel.text) == "name"
    }

    func testWhenItemIsSpicyTextIsItemNameWithChiliEmoji() {
        let item = MenuItem.fixture(name: "name", spicy: true)
        let viewModel = MenuRow.ViewModel(item: item)
        expect(viewModel.text) == "name 🔥"
    }
}
