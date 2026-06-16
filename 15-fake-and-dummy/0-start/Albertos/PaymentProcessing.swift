protocol PaymentProcessing {

  func process(order: Order) async throws
}
