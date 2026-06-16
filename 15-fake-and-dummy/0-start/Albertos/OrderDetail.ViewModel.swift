import Combine
import Foundation
import HippoPayments

// This is just a placeholder to make working on the screen as
// we progress with the chapters easier.
extension OrderDetail {

  class ViewModel: ObservableObject {

    let headerText = "Your Order"
    @Published private(set) var menuItems: [MenuItem] = []
    @Published private(set) var totalPriceText: String? = .none
    let checkoutButtonText = "Checkout"

    @Published var shouldShowAlert: Bool = false

    private(set) var alertViewModel: AlertViewModel?

    private let orderController: OrderController
    private let paymentProcessor: PaymentProcessing
    private let onAlertDismiss: () -> Void

    private var cancellables = Set<AnyCancellable>()

    init(
      orderController: OrderController,
      // TODO: Using a default value for PaymentProcessing
      // just to make the code compile while integrating.
      // Remove once done.
      paymentProcessor: PaymentProcessing =
        HippoPaymentsProcessor(apiKey: "123ABC"),
      onAlertDismiss: @escaping () -> Void
    ) {
      self.orderController = orderController
      self.paymentProcessor = paymentProcessor
      self.onAlertDismiss = onAlertDismiss

      orderController.$order
        .sink { [weak self] order in
          guard let self else { return }

          menuItems = order.items

          if order.items.isEmpty {
            totalPriceText = .none
          } else {
            let formatted = String(format: "%.2f", order.total)
            totalPriceText = "Total: $\(formatted)"
          }
        }
        .store(in: &cancellables)
    }

    func checkout() async throws {
      do {
        try await paymentProcessor.process(
          order: orderController.order
        )

        shouldShowAlert = true
        alertViewModel = AlertViewModel(
          titleText: "Payment succeeded",
          messageText: "Your order will be with you shortly.",
          dismissButtonText: "OK",
          dismissButtonAction: { [weak self] in
            guard let self else { return }

            self.orderController.reset()
            self.onAlertDismiss()
          }
        )
      } catch {
        shouldShowAlert = true
        alertViewModel = AlertViewModel(
          titleText: "Payment failed",
          messageText: "Please contact a waiter.",
          dismissButtonText: "Dismiss",
          dismissButtonAction: onAlertDismiss
        )

        throw error
      }
    }

    func checkout() {
      Task {
        try await checkout()
      }
    }
  }
}
