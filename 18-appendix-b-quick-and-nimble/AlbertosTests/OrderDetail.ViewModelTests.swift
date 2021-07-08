@testable import Albertos
import Nimble
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

        let viewModel = OrderDetail.ViewModel(
            orderController: orderController,
            paymentProcessor: paymentProcessingSpy,
            onAlertDismiss: alertDismissDummy
        )

        viewModel.checkout()

        expect(paymentProcessingSpy.receivedOrder) == orderController.order
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
        let viewModel = OrderDetail.ViewModel(
            orderController: orderController,
            paymentProcessor: PaymentProcessingStub(returning: .success(())),
            onAlertDismiss: { called = true }
        )

        viewModel.checkout()

        // Use this expectation to wait till `alertToShow` is set.
        expect(viewModel.alertToShow).toEventuallyNot(beNil())
        // Now that we have a value, we can run synchronous expectations
        expect(viewModel.alertToShow?.title) == ""
        expect(viewModel.alertToShow?.message) == "The payment was successful. Your food will be with you shortly."
        expect(viewModel.alertToShow?.buttonText) == "Ok"
        // This approach is more linear than `XCTNSPredicateExpectation` and runs faster, too.
        //
        // Adopting it allows us to have three dedicated tests instead of this single one, which we
        // setup to pay the long wait time of the predicate expectation only once. I won't be doing
        // it straightaway because I'll be converting the codebase to Quick next.

        XCTAssertEqual(viewModel.alertToShow?.title, "")
        XCTAssertEqual(
            viewModel.alertToShow?.message,
            "The payment was successful. Your food will be with you shortly."
        )
        XCTAssertEqual(viewModel.alertToShow?.buttonText, "Ok")

        viewModel.alertToShow?.buttonAction?()
        expect(called) == true

        // Verify the order has been reset
        expect(orderController.order.items).to(beEmpty())
    }

    // Because testing with NSPredicate is slow, we use the same test scaffold to test two
    // behaviors. When the payment succeeded the ViewModel updates its `alertToShow` property:
    //
    // - with the expected settings for the success confirmation
    // - with the given callback to run as the button action
    func testWhenPaymentFailsUpdatesPropertyToShowErrorAlertThatCallsDismissCallback() {
        var called = false
        let viewModel = OrderDetail.ViewModel(
            orderController: OrderController(orderStoring: OrderStoringFake()),
            paymentProcessor: PaymentProcessingStub(returning: .failure(TestError(id: 123))),
            onAlertDismiss: { called = true }
        )

        viewModel.checkout()

        expect(viewModel.alertToShow).toEventuallyNot(beNil())
        expect(viewModel.alertToShow?.title) == ""
        expect(viewModel.alertToShow?.message) == "There's been an error with your order. Please contact a waiter."
        expect(viewModel.alertToShow?.buttonText) == "Ok"

        XCTAssertEqual(viewModel.alertToShow?.title, "")
        XCTAssertEqual(
            viewModel.alertToShow?.message,
            "There's been an error with your order. Please contact a waiter."
        )
        XCTAssertEqual(viewModel.alertToShow?.buttonText, "Ok")

        viewModel.alertToShow?.buttonAction?()
        expect(called) == true
    }

    func testWhenOrderIsEmptyShouldNotShowTotalAmount() {
        let viewModel = OrderDetail.ViewModel(
            orderController: OrderController(orderStoring: OrderStoringFake()),
            paymentProcessor: PaymentProcessingDummy(),
            onAlertDismiss: alertDismissDummy
        )

        expect(viewModel.totalText).to(beNil())
    }

    func testWhenOrderIsNonEmptyShouldShowTotalAmount() {
        let orderController = OrderController(orderStoring: OrderStoringFake())
        orderController.addToOrder(item: .fixture(price: 1.0))
        orderController.addToOrder(item: .fixture(price: 2.3))
        let viewModel = OrderDetail.ViewModel(
            orderController: orderController,
            paymentProcessor: PaymentProcessingDummy(),
            onAlertDismiss: alertDismissDummy
        )

        expect(viewModel.totalText) == "Total: $3.30"
    }

    func testWhenOrderIsEmptyHasNotItemNamesToShow() {
        let viewModel = OrderDetail.ViewModel(
            orderController: OrderController(orderStoring: OrderStoringFake()),
            paymentProcessor: PaymentProcessingDummy(),
            onAlertDismiss: alertDismissDummy
        )

        expect(viewModel.menuListItems).to(beEmpty())
    }

    func testWhenOrderIsEmptyDoesNotShowCheckoutButton() {
        let viewModel = OrderDetail.ViewModel(
            orderController: OrderController(orderStoring: OrderStoringFake()),
            paymentProcessor: PaymentProcessingDummy(),
            onAlertDismiss: alertDismissDummy
        )

        expect(viewModel.shouldShowCheckoutButton) == false
    }

    func testWhenOrderIsNonEmptyMenuListItemIsOrderItems() {
        let orderController = OrderController(orderStoring: OrderStoringFake())
        orderController.addToOrder(item: .fixture(name: "a name"))
        orderController.addToOrder(item: .fixture(name: "another name"))
        let viewModel = OrderDetail.ViewModel(
            orderController: orderController,
            paymentProcessor: PaymentProcessingDummy(),
            onAlertDismiss: alertDismissDummy
        )

        expect(viewModel.menuListItems).to(haveCount(2))
        expect(viewModel.menuListItems.first?.name) == "a name"
        expect(viewModel.menuListItems.last?.name) == "another name"
    }

    func testWhenOrderIsNonEmptyShowsCheckoutButton() {
        let orderController = OrderController(orderStoring: OrderStoringFake())
        orderController.addToOrder(item: .fixture(name: "a name"))
        let viewModel = OrderDetail.ViewModel(
            orderController: orderController,
            paymentProcessor: PaymentProcessingDummy(),
            onAlertDismiss: alertDismissDummy
        )

        expect(viewModel.shouldShowCheckoutButton) == true
    }
}
