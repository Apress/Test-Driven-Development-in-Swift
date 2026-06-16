@testable import Albertos

class PaymentProcessingSpy: PaymentProcessing {

  private(set) var receivedOrder: Order?

  func process(order: Order) async throws {
    receivedOrder = order
  }
}
