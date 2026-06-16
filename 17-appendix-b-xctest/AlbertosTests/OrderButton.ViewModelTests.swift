@testable import Albertos
import Testing

struct `OrderButton ViewModel` {

  @Test func `with empty order text does not show total`() {
    let viewModel = OrderButton.ViewModel(
      orderController: OrderController.buildForTesting()
    )

    #expect(viewModel.text == "Your Order")
  }

  @Test func `with non-empty order text shows total price`() {
    let orderController = OrderController.buildForTesting()
    orderController.addToOrder(item: .fixture(price: 1.0))
    orderController.addToOrder(item: .fixture(price: 2.3))
    let viewModel = OrderButton.ViewModel(
      orderController: orderController
    )

    #expect(viewModel.text == "Your Order $3.30")
  }
}
