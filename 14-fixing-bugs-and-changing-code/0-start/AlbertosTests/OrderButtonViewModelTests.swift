@testable import Albertos
import XCTest

class OrderButtonViewModelTests: XCTestCase {

    func testWhenOrderIsEmptyDoesNotShowTotal() {
        let orderController = OrderController()
        let viewModel = OrderButton.ViewModel(orderController: orderController)

        XCTAssertEqual(viewModel.text, "Your Order")
    }

    func testWhenOrderIsNotEmptyShowsTotal() {
        let orderController = OrderController()
        orderController.addToOrder(item: .fixture(price: 1.0))
        orderController.addToOrder(item: .fixture(price: 2.3))
        let viewModel = OrderButton.ViewModel(orderController: orderController)

        XCTAssertEqual(viewModel.text, "Your Order $3.30")
    }
}

