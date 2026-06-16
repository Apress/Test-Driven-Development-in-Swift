@testable import Albertos

extension OrderController {

  static func buildForTesting(
    orderStoring: OrderStoring = OrderStoringFake()
  ) -> OrderController {
    return OrderController(orderStoring: orderStoring)
  }
}
