import Combine
import Foundation

// This is just a placeholder to make working on the screen as
// we progress with the chapters easier.
extension OrderDetail {

  class ViewModel: ObservableObject {

    let headerText = "Your Order"
    @Published private(set) var menuItems: [MenuItem] = []
    @Published private(set) var totalPriceText: String? = .none

    private let orderController: OrderController

    private var cancellables = Set<AnyCancellable>()

    init(orderController: OrderController) {
      self.orderController = orderController

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
  }
}
