@testable import Albertos
import Combine

class PaymentProcessingSpy: PaymentProcessing {

    private(set) var receivedOrder: Order?

    func process(order: Order) -> AnyPublisher<Void, Error> {
        receivedOrder = order

        return Result<Void, Error>.success(()).publisher.eraseToAnyPublisher()
    }
}
