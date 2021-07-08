@testable import Albertos
import XCTest

class OrderDetailViewModelTests: XCTestCase {

    func testWhenCheckoutButtonPressedStartsPaymentProcessingFlow() {
        // Create an OrderController and add some items to it
        let orderController = OrderController()
        orderController.addToOrder(item: .fixture(name: "name"))
        orderController.addToOrder(item: .fixture(name: "other name"))
        // Create the Spy
        let paymentProcessingSpy = PaymentProcessingSpy()

        let viewModel = OrderDetail.ViewModel(
            orderController: orderController,
            paymentProcessor: paymentProcessingSpy,
            onAlertDismiss: {}
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
        let orderController = OrderController()
        orderController.addToOrder(item: .fixture())

        // Set a spy value for the dismiss callback
        var called = false
        let viewModel = OrderDetail.ViewModel(
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
        let viewModel = OrderDetail.ViewModel(
            orderController: OrderController(),
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
        let viewModel = OrderDetail.ViewModel(
            orderController: OrderController(),
            paymentProcessor: PaymentProcessingSpy(),
            onAlertDismiss: {}
        )

        XCTAssertNil(viewModel.totalText)
    }

    func testWhenOrderIsNonEmptyShouldShowTotalAmount() {
        let orderController = OrderController()
        orderController.addToOrder(item: .fixture(price: 1.0))
        orderController.addToOrder(item: .fixture(price: 2.3))
        let viewModel = OrderDetail.ViewModel(
            orderController: orderController,
            paymentProcessor: PaymentProcessingSpy(),
            onAlertDismiss: {}
        )

        XCTAssertEqual(viewModel.totalText, "Total: $3.30")
    }

    func testWhenOrderIsEmptyHasNotItemNamesToShow() {
        let viewModel = OrderDetail.ViewModel(
            orderController: OrderController(),
            paymentProcessor: PaymentProcessingSpy(),
            onAlertDismiss: {}
        )

        XCTAssertEqual(viewModel.menuListItems.count, 0)
    }

    func testWhenOrderIsEmptyDoesNotShowCheckoutButton() {
        let viewModel = OrderDetail.ViewModel(
            orderController: OrderController(),
            paymentProcessor: PaymentProcessingSpy(),
            onAlertDismiss: {}
        )

        XCTAssertFalse(viewModel.shouldShowCheckoutButton)
    }

    func testWhenOrderIsNonEmptyMenuListItemIsOrderItems() {
        let orderController = OrderController()
        orderController.addToOrder(item: .fixture(name: "a name"))
        orderController.addToOrder(item: .fixture(name: "another name"))
        let viewModel = OrderDetail.ViewModel(
            orderController: orderController,
            paymentProcessor: PaymentProcessingSpy(),
            onAlertDismiss: {}
        )

        XCTAssertEqual(viewModel.menuListItems.count, 2)
        XCTAssertEqual(viewModel.menuListItems.first?.name, "a name")
        XCTAssertEqual(viewModel.menuListItems.last?.name, "another name")
    }

    func testWhenOrderIsNonEmptyShowsCheckoutButton() {
        let orderController = OrderController()
        orderController.addToOrder(item: .fixture(name: "a name"))
        let viewModel = OrderDetail.ViewModel(
            orderController: orderController,
            paymentProcessor: PaymentProcessingSpy(),
            onAlertDismiss: {}
        )

        XCTAssertTrue(viewModel.shouldShowCheckoutButton)
    }
}
