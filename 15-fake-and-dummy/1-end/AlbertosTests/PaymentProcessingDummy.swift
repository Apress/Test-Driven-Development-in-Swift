@testable import Albertos
import Combine

class PaymentProcessingDummy: PaymentProcessing {

    // When implementing a dummy that has to return a result, like in this case, choose the simplest
    // code you can to make the it compile. Because dummies are meant to be used as placeholder
    // only, it doesn't matter what output they provide.
    func process(order: Order) -> AnyPublisher<Void, Error> {
        return Result<Void, Error>.success(()).publisher.eraseToAnyPublisher()
    }
}
