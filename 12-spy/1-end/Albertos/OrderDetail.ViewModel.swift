import Combine
import HippoPayments

extension OrderDetail {

    struct ViewModel {

        let headerText = "Your Order"
        let menuListItems: [MenuItem]
        let emptyMenuFallbackText = "Add dishes to the order to see them here"
        let totalText: String?

        let shouldShowCheckoutButton: Bool
        let checkoutButtonText = "Checkout"

        private let orderController: OrderController
        private let paymentProcessor: PaymentProcessing

        init(orderController: OrderController, paymentProcessor: PaymentProcessing) {
            self.orderController = orderController
            self.paymentProcessor = paymentProcessor

            if orderController.order.items.isEmpty {
                totalText = .none
                shouldShowCheckoutButton = false
            } else {
                totalText = "Total: $\(String(format: "%.2f", orderController.order.total))"
                shouldShowCheckoutButton = true
            }

            menuListItems = orderController.order.items
        }

        func checkout() {
            paymentProcessor.process(order: orderController.order)
        }
    }
}
