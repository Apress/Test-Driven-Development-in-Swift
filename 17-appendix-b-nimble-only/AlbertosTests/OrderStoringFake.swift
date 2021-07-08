@testable import Albertos

class OrderStoringFake: OrderStoring {

    private var order: Order = Order(items: [])

    func getOrder() -> Order {
        return order
    }

    func updateOrder(_ order: Order) {
        self.order = order
    }
}
