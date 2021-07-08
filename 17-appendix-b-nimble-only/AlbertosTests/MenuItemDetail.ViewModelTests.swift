@testable import Albertos
import Nimble
import XCTest

class MenuItemDetailViewModelTests: XCTestCase {

    func testWhenItemIsInOrderButtonSaysRemove() {
        let item = MenuItem.fixture()
        let orderController = OrderController(orderStoring: OrderStoringFake())
        orderController.addToOrder(item: item)
        let viewModel = MenuItemDetail.ViewModel(item: item, orderController: orderController)

        let text = viewModel.addOrRemoveFromOrderButtonText

        expect(text) == "Remove from order"
    }

    func testWhenItemIsNotInOrderButtonSaysAdd() {
        let item = MenuItem.fixture()
        let orderController = OrderController(orderStoring: OrderStoringFake())
        let viewModel = MenuItemDetail.ViewModel(item: item, orderController: orderController)

        let text = viewModel.addOrRemoveFromOrderButtonText

        expect(text) == "Add to order"
    }

    func testWhenItemIsInOrderButtonActionRemovesIt() {
        let item = MenuItem.fixture()
        let orderController = OrderController(orderStoring: OrderStoringFake())
        orderController.addToOrder(item: item)
        let viewModel = MenuItemDetail.ViewModel(item: item, orderController: orderController)

        viewModel.addOrRemoveFromOrder()

        expect(orderController.order.items).toNot(containElementSatisfying({ $0 == item }))
    }

    func testWhenItemIsNotInOrderButtonActionAddsIt() {
        let item = MenuItem.fixture()
        let orderController = OrderController(orderStoring: OrderStoringFake())
        let viewModel = MenuItemDetail.ViewModel(item: item, orderController: orderController)

        viewModel.addOrRemoveFromOrder()

        expect(orderController.order.items).to(containElementSatisfying({ $0 == item }))
    }

    func testNameIsItemName() {
        expect(
            MenuItemDetail.ViewModel(item: .fixture(name: "a name"), orderController: OrderController()).name
        ) == "a name"
    }

    func testWhenItemIsSpicyShowsSpicyMessage() {
        expect(
            MenuItemDetail.ViewModel(item: .fixture(spicy: true), orderController: OrderController()).spicy
        ) == "Spicy"
    }

    func testWhenItemIsNotSpicyDoesNotShowSpicyMessage() {
        expect(MenuItemDetail.ViewModel(item: .fixture(spicy: false), orderController: OrderController()).spicy).to(beNil())
    }

    func testPriceIsFormattedItemPrice() {
        expect(
            MenuItemDetail.ViewModel(item: .fixture(price: 1.0), orderController: OrderController()).price
        ) == "$1.00"
        expect(
            MenuItemDetail.ViewModel(item: .fixture(price: 2.5), orderController: OrderController()).price
        ) == "$2.50"
        expect(
            MenuItemDetail.ViewModel(item: .fixture(price: 3.45), orderController: OrderController()).price
        ) == "$3.45"
        expect(
            MenuItemDetail.ViewModel(item: .fixture(price: 4.123), orderController: OrderController()).price
        ) == "$4.12"
    }
}
