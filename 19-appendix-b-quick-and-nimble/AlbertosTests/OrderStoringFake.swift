@testable import Albertos

class OrderStoringFake: OrderStoring {

  private var order: Order

  init(order: Order = Order(items: [])) {
    self.order = order
  }

  func getOrder() -> Order {
    return order
  }

  func updateOrder(_ newOrder: Order) {
    order = newOrder
  }
}
