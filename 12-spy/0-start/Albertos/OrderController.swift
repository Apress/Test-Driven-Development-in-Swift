import Combine

class OrderController: ObservableObject {

    @Published private(set) var order: Order

    init(order: Order = Order(items: [])) {
        self.order = order
    }

    func isItemInOrder(_ item: MenuItem) -> Bool {
        return order.items.contains { $0 == item }
    }

    func addToOrder(item: MenuItem) {
        order = Order(items: order.items + [item])
    }

    func removeFromOrder(item: MenuItem) {
        let items = order.items
        guard let indexToRemove = items.firstIndex(where: { $0.name == item.name }) else { return }

        let newItems = items.enumerated().compactMap { (index, element) -> MenuItem? in
            guard index == indexToRemove else { return element }
            return .none
        }

        order = Order(items: newItems)
    }
}
