import Testing
@testable import Albertos

@MainActor
struct `OrderDetail ViewModel` {

  let dummyClosure: () -> Void = {}

  @Test func `when order is empty does not expose total`() {
    let viewModel = OrderDetailViewModel(
      orderController: OrderController(
        orderStoring: OrderStoringFake()
      ),
      paymentProcessor: PaymentProcessingDummy(),
      onAlertDismiss: dummyClosure
    )

    #expect(viewModel.totalPriceText == .none)
  }

  @Test func `when order is not empty exposes total`() {
    let orderController = OrderController(
      orderStoring: OrderStoringFake()
    )
    orderController.addToOrder(item: .fixture(price: 1.5))
    orderController.addToOrder(item: .fixture(price: 1.0))
    let viewModel = OrderDetailViewModel(
      orderController: orderController,
      onAlertDismiss: {}
    )

    #expect(viewModel.totalPriceText == "Total: $2.50")
  }

  @Test func `when order is empty does not show items`() {
    let viewModel = OrderDetailViewModel(
      orderController: OrderController(
        orderStoring: OrderStoringFake()
      ),
      onAlertDismiss: {}
    )

    #expect(viewModel.menuItems.isEmpty == true)
  }

  @Test func `when order is not empty shows item names`() {
    let orderController = OrderController(
      orderStoring: OrderStoringFake()
    )
    orderController.addToOrder(item: .fixture(name: "Item 1"))
    orderController.addToOrder(item: .fixture(name: "Item 2"))
    orderController.addToOrder(item: .fixture(name: "Item 3"))
    let viewModel = OrderDetailViewModel(
      orderController: orderController,
      onAlertDismiss: {}
    )

    #expect(viewModel.menuItems.count == 3)
    #expect(viewModel.menuItems[safe: 0]?.name == "Item 1")
    #expect(viewModel.menuItems[safe: 1]?.name == "Item 2")
    #expect(viewModel.menuItems[safe: 2]?.name == "Item 3")
  }

  @Test
  func `checkout starts payment processing`() async throws {
    let orderController = OrderController(
      orderStoring: OrderStoringFake()
    )
    orderController.addToOrder(item: .fixture())
    let paymentProcessingSpy = PaymentProcessingSpy()
    let viewModel = OrderDetailViewModel(
      orderController: orderController,
      paymentProcessor: paymentProcessingSpy,
      onAlertDismiss: {}
    )

    try await viewModel.checkout()

    #expect(
      paymentProcessingSpy.receivedOrder
      ==
      orderController.order
    )
  }

  @Test
  func `payment ok shows confirmation alert`() async throws {
    let orderController = OrderController(
      orderStoring: OrderStoringFake()
    )
    orderController.addToOrder(item: .fixture())
    let paymentProcessingSpy = PaymentProcessingStub(
      returning: .success(())
    )
    let viewModel = OrderDetailViewModel(
      orderController: orderController,
      paymentProcessor: paymentProcessingSpy,
      onAlertDismiss: {}
    )

    try await viewModel.checkout()

    #expect(viewModel.shouldShowAlert == true)
    #expect(
      viewModel.alertViewModel?.titleText
      ==
      "Payment succeeded"
    )
    #expect(
      viewModel.alertViewModel?.messageText
      ==
      "Your order will be with you shortly."
    )
    #expect(
      viewModel.alertViewModel?.dismissButtonText
      ==
      "OK"
    )
  }

  @Test
  func `payment ok configures alert action`() async throws {
    let orderController = OrderController(
      orderStoring: OrderStoringFake()
    )
    orderController.addToOrder(item: .fixture())
    let paymentProcessingSpy = PaymentProcessingStub(
      returning: .success(())
    )
    var actionDidRun = false
    let viewModel = OrderDetailViewModel(
      orderController: orderController,
      paymentProcessor: paymentProcessingSpy,
      onAlertDismiss: { actionDidRun = true }
    )

    try await viewModel.checkout()

    viewModel.alertViewModel?.dismissButtonAction()

    #expect(actionDidRun)
  }

  @Test
  func `payment ko shows information alert`() async throws {
    let orderController = OrderController(
      orderStoring: OrderStoringFake()
    )
    orderController.addToOrder(item: .fixture())
    let paymentProcessingSpy = PaymentProcessingStub(
      returning: .failure(TestError(id: 1))
    )
    let viewModel = OrderDetailViewModel(
      orderController: orderController,
      paymentProcessor: paymentProcessingSpy,
      onAlertDismiss: {}
    )

    await #expect(
      throws: TestError.self,
      performing: {
        try await viewModel.checkout()
      }
    )

    #expect(viewModel.shouldShowAlert == true)
    #expect(
      viewModel.alertViewModel?.titleText
      ==
      "Payment failed"
    )
    #expect(
      viewModel.alertViewModel?.messageText
      ==
      "Please contact a waiter."
    )
    #expect(
      viewModel.alertViewModel?.dismissButtonText
      ==
      "Dismiss"
    )
  }

  @Test
  func `payment ok dismiss resets order`() async throws {
    let orderController = OrderController()
    orderController.addToOrder(item: .fixture())
    let paymentProcessingSpy = PaymentProcessingStub(
      returning: .success(())
    )
    let viewModel = OrderDetailViewModel(
      orderController: orderController,
      paymentProcessor: paymentProcessingSpy,
      onAlertDismiss: {}
    )

    try await viewModel.checkout()

    viewModel.alertViewModel?.dismissButtonAction()

    #expect(orderController.order.items.isEmpty)
  }

  @Test
  func `payment ko configures alert action`() async throws {
    let orderController = OrderController()
    orderController.addToOrder(item: .fixture())
    let paymentProcessingSpy = PaymentProcessingStub(
      returning: .failure(TestError(id: 1))
    )
    var actionDidRun = false
    let viewModel = OrderDetailViewModel(
      orderController: orderController,
      paymentProcessor: paymentProcessingSpy,
      onAlertDismiss: { actionDidRun = true }
    )

    await #expect(
      throws: TestError.self,
      performing: {
        try await viewModel.checkout()
      }
    )

    viewModel.alertViewModel?.dismissButtonAction()

    #expect(actionDidRun)
  }
}
