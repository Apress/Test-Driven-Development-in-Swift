import Testing
@testable import Albertos

@MainActor
struct `OrderDetail ViewModel` {

  let dummyClosure: () -> Void = {}

  @Test func `when order is empty does not expose total`() {
    let viewModel = OrderDetail.ViewModel(
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
    let viewModel = OrderDetail.ViewModel(
      orderController: orderController,
      onAlertDismiss: {}
    )

    #expect(viewModel.totalPriceText == "Total: $2.50")
  }

  @Test func `when order is empty does not show items`() {
    let viewModel = OrderDetail.ViewModel(
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
    let viewModel = OrderDetail.ViewModel(
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
    let viewModel = OrderDetail.ViewModel(
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
    let viewModel = OrderDetail.ViewModel(
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
    let viewModel = OrderDetail.ViewModel(
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
    let viewModel = OrderDetail.ViewModel(
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
    let viewModel = OrderDetail.ViewModel(
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
    let viewModel = OrderDetail.ViewModel(
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

import Nimble

@MainActor
struct `Nimble Experiments`{

  @Test
  func `payment ko shows information alert`() async {
    let orderController = OrderController(
      orderStoring: OrderStoringFake()
    )
    orderController.addToOrder(item: .fixture())
    let paymentProcessingSpy = PaymentProcessingStub(
      returning: .failure(TestError(id: 1))
    )
    let viewModel = OrderDetail.ViewModel(
      orderController: orderController,
      paymentProcessor: paymentProcessingSpy,
      onAlertDismiss: {}
    )

    // Notice below the wrapper around the non-async checkout.
    // This is so the compiler can distinguish between the two.
    // Otherwise, it would try to use the async version here.
    viewModel.checkoutSync()

    // This gives the queued Task from checkout a chance to
    // execute on the MainActor.
    //
    // After the yield, the async work has had an opportunity to
    // start.
    //
    // It's then up to the toEventually to wait for it to
    // complete.
    await Task.yield()

    await expect(viewModel.shouldShowAlert)
      .toEventually(beTrue())
    // Technically, these don't need to be toEventually because
    // we already waited with the assertion above.
    // But I find having them as toEventually, too, conveys
    // their connection with the asynchronous flow.
    await expect(viewModel.alertViewModel?.titleText)
      .toEventually(equal("Payment failed"))
    await expect(viewModel.alertViewModel?.messageText)
      .toEventually(equal("Please contact a waiter."))
    await expect(viewModel.alertViewModel?.dismissButtonText)
      .toEventually(equal("Dismiss"))
  }
}

extension OrderDetail.ViewModel {

  /// Wraps the synchronous `checkout()` implementation and gives it a different
  /// name so that the compiler can disambiguate between the two when compiling
  /// a test where we want to use the synchrous version.
  ///
  /// Otherwise, we get: Expression is 'async' but is not marked with 'await'.
  func checkoutSync() {
    checkout()
  }
}
