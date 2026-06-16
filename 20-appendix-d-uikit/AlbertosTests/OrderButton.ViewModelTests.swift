@testable import Albertos
import Testing

struct `OrderButton ViewModel` {

  @Test func `with empty order text does not show total`() {
    let viewModel = OrderButtonViewModel(
      orderController: OrderController(
        orderStoring: OrderStoringFake()
      )
    )

    #expect(viewModel.text == "Your Order")
  }

  @Test func `with non-empty order text shows total price`() {
    let orderController = OrderController(
      orderStoring: OrderStoringFake()
    )
    orderController.addToOrder(item: .fixture(price: 1.0))
    orderController.addToOrder(item: .fixture(price: 2.3))
    let viewModel = OrderButtonViewModel(
      orderController: orderController
    )

    #expect(viewModel.text == "Your Order $3.30")
  }
}
