import HippoPayments

extension HippoPaymentsProcessor: PaymentProcessing {

  func process(order: Order) async throws {
    try await withCheckedThrowingContinuation { continuation in
      processPayment(
        payload: [:],
        onSuccess: {
          continuation.resume()
        },
        onFailure: { error in
          continuation.resume(throwing: error)
        }
      )
    }
  }
}
