import Combine

protocol PaymentProcessing {

    func process(order: Order) -> AnyPublisher<Void, Error>
}
