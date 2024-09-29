@testable import Albertos

class OrderStoringFake: OrderStoring {
    private var order: Order = .init(items: [])

    func getOrder() -> Order {
        order
    }

    func updateOrder(_ order: Order) {
        self.order = order
    }
}
