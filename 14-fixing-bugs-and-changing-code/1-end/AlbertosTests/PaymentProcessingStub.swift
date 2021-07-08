@testable import Albertos
import Combine
import Foundation

class PaymentProcessingStub: PaymentProcessing {

    let result: Result<Void, Error>

    init(returning result: Result<Void, Error>) {
        self.result = result
    }

    func process(order: Order) -> AnyPublisher<Void, Error> {
        return result.publisher
            // Use a delay to simulate the real world async behavior
            .delay(for: 0.01, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
