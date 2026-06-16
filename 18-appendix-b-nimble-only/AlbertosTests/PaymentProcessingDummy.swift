@testable import Albertos

struct PaymentProcessingDummy: PaymentProcessing {

  func process(order: Order) async throws {}
}
