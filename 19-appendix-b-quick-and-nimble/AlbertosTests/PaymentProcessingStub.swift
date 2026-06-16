@testable import Albertos

class PaymentProcessingStub: PaymentProcessing {

  private let result: Result<Void, Error>

  init(returning result: Result<Void, Error>) {
    self.result = result
  }

  func process(order: Order) async throws {
    // Sleep to emulate the real world async behavior
    try await Task.sleep(for: .milliseconds(100))
    switch result {
    case .success: return ()
    case .failure(let error): throw error
    }
  }
}
