@testable import Albertos
import XCTest

class OrderDetailViewModelTests: XCTestCase {

    let alertDismissDummy: () -> Void = {}

    func testWhenCheckoutButtonPressedStartsPaymentProcessingFlow() {
        // Create an OrderController and add some items to it
        let orderController = OrderController(orderStoring: OrderStoringFake())
        orderController.addToOrder(item: .fixture(name: "name"))
        orderController.addToOrder(item: .fixture(name: "other name"))
        // Create the Spy
        let paymentProcessingSpy = PaymentProcessingSpy()

        let viewModel = OrderDetailViewModel(
            orderController: orderController,
            paymentProcessor: paymentProcessingSpy,
            onAlertDismiss: alertDismissDummy
        )

        viewModel.checkout()

        XCTAssertEqual(paymentProcessingSpy.receivedOrder, orderController.order)
    }

    // Because testing with NSPredicate is slow, we use the same test scaffold to test two
    // behaviors. When the payment succeeded the ViewModel updates its `alertToShow` property:
    //
    // - with the expected settings for the success confirmation
    // - with the given callback to run as the button action
    // - when the callback runs, the order is reset
    func testWhenPaymentSucceedsUpdatesPropertyToShowConfirmationAlertThatCallsDimissCallback() {
        // Arrange the input state with a valid order, one that has items
        let orderController = OrderController(orderStoring: OrderStoringFake())
        orderController.addToOrder(item: .fixture())

        // Set a spy value for the dismiss callback
        var called = false
        let viewModel = OrderDetailViewModel(
            orderController: orderController,
            paymentProcessor: PaymentProcessingStub(returning: .success(())),
            onAlertDismiss: { called = true }
        )

        let predicate = NSPredicate { _, _ in viewModel.alertToShow != nil }
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: .none)

        viewModel.checkout()

        wait(for: [expectation], timeout: timeoutForPredicateExpectations)

        XCTAssertEqual(viewModel.alertToShow?.title, "")
        XCTAssertEqual(
            viewModel.alertToShow?.message,
            "The payment was successful. Your food will be with you shortly."
        )
        XCTAssertEqual(viewModel.alertToShow?.buttonText, "Ok")

        viewModel.alertToShow?.buttonAction?()
        XCTAssertTrue(called)

        // Verify the order has been reset
        XCTAssertTrue(orderController.order.items.isEmpty)
    }

    // Because testing with NSPredicate is slow, we use the same test scaffold to test two
    // behaviors. When the payment succeeded the ViewModel updates its `alertToShow` property:
    //
    // - with the expected settings for the success confirmation
    // - with the given callback to run as the button action
    func testWhenPaymentFailsUpdatesPropertyToShowErrorAlertThatCallsDismissCallback() {
        var called = false
        let viewModel = OrderDetailViewModel(
            orderController: OrderController(orderStoring: OrderStoringFake()),
            paymentProcessor: PaymentProcessingStub(returning: .failure(TestError(id: 123))),
            onAlertDismiss: { called = true }
        )

        let predicate = NSPredicate { _, _ in viewModel.alertToShow != nil }
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: .none)

        viewModel.checkout()

        wait(for: [expectation], timeout: timeoutForPredicateExpectations)

        XCTAssertEqual(viewModel.alertToShow?.title, "")
        XCTAssertEqual(
            viewModel.alertToShow?.message,
            "There's been an error with your order. Please contact a waiter."
        )
        XCTAssertEqual(viewModel.alertToShow?.buttonText, "Ok")

        viewModel.alertToShow?.buttonAction?()
        XCTAssertTrue(called)
    }

    func testWhenOrderIsEmptyShouldNotShowTotalAmount() {
        let viewModel = OrderDetailViewModel(
            orderController: OrderController(orderStoring: OrderStoringFake()),
            paymentProcessor: PaymentProcessingDummy(),
            onAlertDismiss: alertDismissDummy
        )

        XCTAssertNil(viewModel.totalText)
    }

    func testWhenOrderIsNonEmptyShouldShowTotalAmount() {
        let orderController = OrderController(orderStoring: OrderStoringFake())
        orderController.addToOrder(item: .fixture(price: 1.0))
        orderController.addToOrder(item: .fixture(price: 2.3))
        let viewModel = OrderDetailViewModel(
            orderController: orderController,
            paymentProcessor: PaymentProcessingDummy(),
            onAlertDismiss: alertDismissDummy
        )

        XCTAssertEqual(viewModel.totalText, "Total: $3.30")
    }

    func testWhenOrderIsEmptyHasNotItemNamesToShow() {
        let viewModel = OrderDetailViewModel(
            orderController: OrderController(orderStoring: OrderStoringFake()),
            paymentProcessor: PaymentProcessingDummy(),
            onAlertDismiss: alertDismissDummy
        )

        XCTAssertEqual(viewModel.menuListItems.count, 0)
    }

    func testWhenOrderIsEmptyDoesNotShowCheckoutButton() {
        let viewModel = OrderDetailViewModel(
            orderController: OrderController(orderStoring: OrderStoringFake()),
            paymentProcessor: PaymentProcessingDummy(),
            onAlertDismiss: alertDismissDummy
        )

        XCTAssertFalse(viewModel.shouldShowCheckoutButton)
    }

    func testWhenOrderIsNonEmptyMenuListItemIsOrderItems() {
        let orderController = OrderController(orderStoring: OrderStoringFake())
        orderController.addToOrder(item: .fixture(name: "a name"))
        orderController.addToOrder(item: .fixture(name: "another name"))
        let viewModel = OrderDetailViewModel(
            orderController: orderController,
            paymentProcessor: PaymentProcessingDummy(),
            onAlertDismiss: alertDismissDummy
        )

        XCTAssertEqual(viewModel.menuListItems.count, 2)
        XCTAssertEqual(viewModel.menuListItems.first?.name, "a name")
        XCTAssertEqual(viewModel.menuListItems.last?.name, "another name")
    }

    func testWhenOrderIsNonEmptyShowsCheckoutButton() {
        let orderController = OrderController(orderStoring: OrderStoringFake())
        orderController.addToOrder(item: .fixture(name: "a name"))
        let viewModel = OrderDetailViewModel(
            orderController: orderController,
            paymentProcessor: PaymentProcessingDummy(),
            onAlertDismiss: alertDismissDummy
        )

        XCTAssertTrue(viewModel.shouldShowCheckoutButton)
    }
}
