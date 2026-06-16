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

    private let orderController: OrderController
    private let paymentProcessor: PaymentProcessing

    private var cancellables = Set<AnyCancellable>()

    init(
      orderController: OrderController,
      // TODO: Using a default value for PaymentProcessing
      // just to make the code compile while integrating.
      // Remove once done.
      paymentProcessor: PaymentProcessing =
        HippoPaymentsProcessor(apiKey: "123ABC")
    ) {
      self.orderController = orderController
      self.paymentProcessor = paymentProcessor

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

    func checkout() async {
      do {
        try await paymentProcessor.process(
          order: orderController.order
        )
      } catch {
        // TODO: Address the swallowed error
        print(error)
      }
    }

    func checkout() {
      Task {
        await checkout()
      }
    }
  }
}
