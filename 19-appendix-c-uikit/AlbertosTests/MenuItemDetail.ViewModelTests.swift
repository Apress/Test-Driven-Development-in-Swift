@testable import Albertos
import XCTest

class MenuItemDetailViewModelTests: XCTestCase {

    func testWhenItemIsInOrderButtonSaysRemove() {
        let item = MenuItem.fixture()
        let orderController = OrderController(orderStoring: OrderStoringFake())
        orderController.addToOrder(item: item)
        let viewModel = MenuItemDetailViewModel(item: item, orderController: orderController)

        let text = viewModel.addOrRemoveFromOrderButtonText

        XCTAssertEqual(text, "Remove from order")
    }

    func testWhenItemIsNotInOrderButtonSaysAdd() {
        let item = MenuItem.fixture()
        let orderController = OrderController(orderStoring: OrderStoringFake())
        let viewModel = MenuItemDetailViewModel(item: item, orderController: orderController)

        let text = viewModel.addOrRemoveFromOrderButtonText

        XCTAssertEqual(text, "Add to order")
    }

    func testWhenItemIsInOrderButtonActionRemovesIt() {
        let item = MenuItem.fixture()
        let orderController = OrderController(orderStoring: OrderStoringFake())
        orderController.addToOrder(item: item)
        let viewModel = MenuItemDetailViewModel(item: item, orderController: orderController)

        viewModel.addOrRemoveFromOrder()

        XCTAssertFalse(orderController.order.items.contains { $0 == item })
    }

    func testWhenItemIsNotInOrderButtonActionAddsIt() {
        let item = MenuItem.fixture()
        let orderController = OrderController(orderStoring: OrderStoringFake())
        let viewModel = MenuItemDetailViewModel(item: item, orderController: orderController)

        viewModel.addOrRemoveFromOrder()

        XCTAssertTrue(orderController.order.items.contains { $0 == item })
    }

    func testNameIsItemName() {
        XCTAssertEqual(
            MenuItemDetailViewModel(item: .fixture(name: "a name"), orderController: OrderController()).name,
            "a name"
        )
    }

    func testWhenItemIsSpicyShowsSpicyMessage() {
        XCTAssertEqual(
            MenuItemDetailViewModel(item: .fixture(spicy: true), orderController: OrderController()).spicy,
            "Spicy"
        )
    }

    func testWhenItemIsNotSpicyDoesNotShowSpicyMessage() {
        XCTAssertNil(MenuItemDetailViewModel(item: .fixture(spicy: false), orderController: OrderController()).spicy)
    }

    func testPriceIsFormattedItemPrice() {
        XCTAssertEqual(
            MenuItemDetailViewModel(item: .fixture(price: 1.0), orderController: OrderController()).price,
            "$1.00"
        )
        XCTAssertEqual(
            MenuItemDetailViewModel(item: .fixture(price: 2.5), orderController: OrderController()).price,
            "$2.50"
        )
        XCTAssertEqual(
            MenuItemDetailViewModel(item: .fixture(price: 3.45), orderController: OrderController()).price,
            "$3.45"
        )
        XCTAssertEqual(
            MenuItemDetailViewModel(item: .fixture(price: 4.123), orderController: OrderController()).price,
            "$4.12"
        )
    }
}
