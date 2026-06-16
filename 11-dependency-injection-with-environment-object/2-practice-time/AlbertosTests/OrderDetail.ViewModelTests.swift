import Testing
@testable import Albertos

struct `OrderDetail ViewModel` {

  @Test func `when order is empty does not expose total`() {
    let viewModel = OrderDetail.ViewModel(
      orderController: OrderController()
    )

    #expect(viewModel.totalPriceText == .none)
  }

  @Test func `when order is not empty exposes total`() {
    let orderController = OrderController()
    orderController.addToOrder(item: .fixture(price: 1.5))
    orderController.addToOrder(item: .fixture(price: 1.0))
    let viewModel = OrderDetail.ViewModel(
      orderController: orderController
    )

    #expect(viewModel.totalPriceText == "Total: $2.50")
  }

  @Test func `when order is empty does not show items`() {
    let viewModel = OrderDetail.ViewModel(
      orderController: OrderController()
    )

    #expect(viewModel.menuItems.isEmpty == true)
  }

  @Test func `when order is not empty shows item names`() {
    let orderController = OrderController()
    orderController.addToOrder(item: .fixture(name: "Item 1"))
    orderController.addToOrder(item: .fixture(name: "Item 2"))
    orderController.addToOrder(item: .fixture(name: "Item 3"))
    let viewModel = OrderDetail.ViewModel(
      orderController: orderController
    )

    #expect(viewModel.menuItems.count == 3)
    #expect(viewModel.menuItems[safe: 0]?.name == "Item 1")
    #expect(viewModel.menuItems[safe: 1]?.name == "Item 2")
    #expect(viewModel.menuItems[safe: 2]?.name == "Item 3")
  }
}
