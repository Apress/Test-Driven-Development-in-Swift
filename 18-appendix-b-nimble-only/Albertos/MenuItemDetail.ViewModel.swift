import Combine
import Foundation

extension MenuItemDetail {

  class ViewModel: ObservableObject {

    private let item: MenuItem

    let name: String
    let spicy: String?
    let price: String

    @Published
    private(set) var updateOrderButtonText = "Remove from order"

    private let orderController: OrderController

    private var cancellables = Set<AnyCancellable>()

    init(item: MenuItem, orderController: OrderController) {
      self.item = item
      name = item.name
      spicy = item.spicy ? "Spicy" : .none
      price = "$\(String(format: "%.2f", item.price))"

      self.orderController = orderController

      orderController.$order.sink { [weak self] value in
        guard let self else { return }

        if value.items.contains(item) {
          self.updateOrderButtonText = "Remove from order"
        } else {
          self.updateOrderButtonText = "Add to order"
        }
      }
      .store(in: &cancellables)
    }

    func toggleItemInOrder() {
      if orderController.order.items.contains(item) {
        orderController.removeFromOrder(item: item)
      } else {
        orderController.addToOrder(item: item)
      }
    }
  }
}
