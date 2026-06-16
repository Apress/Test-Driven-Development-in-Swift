import Combine
import Foundation

extension OrderButton {

  class ViewModel: ObservableObject  {

    let orderController: OrderController

    @Published private(set) var text = "Your Order"

    private var cancellables = Set<AnyCancellable>()

    init(orderController: OrderController) {
      self.orderController = orderController

      orderController
        .$order
        .sink { [weak self] order in
          guard let self else { return }

          if order.items.isEmpty {
            self.text = "Your Order"
          } else {
            let formatted = String(format: "%.2f", order.total)
            self.text = "Your Order $\(formatted)"

          }
        }
        .store(in: &cancellables)
    }
  }
}
