import Testing
@testable import Albertos

struct `MenuItemDetail ViewModel` {

  @Test func `reads name from item`() {
    let item = MenuItem.fixture(name: "name")
    let viewModel = MenuItemDetail.ViewModel(
      item: item,
      orderController: OrderController(
        orderStoring: OrderStoringFake()
      )
    )

    #expect(viewModel.name == "name")
  }

  @Test func `when item is spicy, has spicy label`() {
    let item = MenuItem.fixture(spicy: true)
    let viewModel = MenuItemDetail.ViewModel(
      item: item,
      orderController: OrderController(
        orderStoring: OrderStoringFake()
      )
    )

    #expect(viewModel.spicy == "Spicy")
  }

  @Test func `when item is not spicy, has no spicy label`() {
    let item = MenuItem.fixture(spicy: false)
    let viewModel = MenuItemDetail.ViewModel(
      item: item,
      orderController: OrderController(
        orderStoring: OrderStoringFake()
      )
    )

    #expect(viewModel.spicy == .none)
  }

  @Test(
    arguments: zip(
      [1.234, 2.345, 3.456],
      ["$1.23", "$2.35", "$3.46"]
    )
  )
  func `shows price with $ sign and rounds to nearest`(
    price: Double,
    expectedValue: String
  ) {
    let item = MenuItem.fixture(price: price)
    let viewModel = MenuItemDetail.ViewModel(
      item: item,
      orderController: OrderController(
        orderStoring: OrderStoringFake()
      )
    )

    #expect(viewModel.price == expectedValue)
  }

  @Test func `when item in order button says remove`() {
    let item = MenuItem.fixture()
    let orderController = OrderController(
      orderStoring: OrderStoringFake()
    )
    orderController.addToOrder(item: item)
    let viewModel = MenuItemDetail.ViewModel(
      item: item,
      orderController: orderController
    )

    let text = viewModel.updateOrderButtonText

    #expect(text == "Remove from order")
  }

  @Test func `when item not in order button says add`() {
    let item = MenuItem.fixture()
    let orderController = OrderController(
      orderStoring: OrderStoringFake()
    )
    let viewModel = MenuItemDetail.ViewModel(
      item: item,
      orderController: orderController
    )

    let text = viewModel.updateOrderButtonText

    #expect(text == "Add to order")
  }

  @Test func `when item in order button action removes it`() {
    let item = MenuItem.fixture()
    let orderController = OrderController(
      orderStoring: OrderStoringFake()
    )
    let viewModel = MenuItemDetail.ViewModel(
      item: item,
      orderController: orderController
    )

    viewModel.toggleItemInOrder()

    #expect(orderController.order.items.contains(item))
  }

  @Test func `when item not in order button action adds it`() {
    let item = MenuItem.fixture()
    let orderController = OrderController(
      orderStoring: OrderStoringFake()
    )
    orderController.addToOrder(item: item)
    let viewModel = MenuItemDetail.ViewModel(
      item: item,
      orderController: orderController
    )

    viewModel.toggleItemInOrder()

    #expect(orderController.order.items.contains(item) == false)
  }
}
