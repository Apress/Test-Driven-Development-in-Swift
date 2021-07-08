@testable import Albertos
import XCTest

class OrderButtonViewModelTests: XCTestCase {

    func testWhenOrderIsEmptyDoesNotShowTotal() {
        let orderController = OrderController(orderStoring: OrderStoringFake())
        let viewModel = OrderButtonViewModel(orderController: orderController)

        XCTAssertEqual(viewModel.text, "Your Order")
    }

    func testWhenOrderIsNotEmptyShowsTotal() {
        let orderController = OrderController(orderStoring: OrderStoringFake())
        orderController.addToOrder(item: .fixture(price: 1.0))
        orderController.addToOrder(item: .fixture(price: 2.3))
        let viewModel = OrderButtonViewModel(orderController: orderController)

        XCTAssertEqual(viewModel.text, "Your Order $3.30")
    }
}

