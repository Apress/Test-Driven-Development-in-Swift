class MenuItemDetailViewModel {

    let name: String
    let spicy: String?
    let price: String
    private(set) var addOrRemoveFromOrderButtonText: String

    private let item: MenuItem
    private let orderController: OrderController

    init(item: MenuItem, orderController: OrderController) {
        self.item = item
        self.orderController = orderController

        name = item.name
        spicy = item.spicy ? "Spicy" : .none
        price = "$\(String(format: "%.2f", item.price))"
        addOrRemoveFromOrderButtonText = getAddOrRemoveFromOrderButtonText(
            item: item,
            order: orderController.order
        )

        if (orderController.order.items.contains { $0 == item }) {
            self.addOrRemoveFromOrderButtonText = "Remove from order"
        } else {
            self.addOrRemoveFromOrderButtonText = "Add to order"
        }
    }

    func addOrRemoveFromOrder() {
        if (orderController.order.items.contains { $0 == item }) {
            orderController.removeFromOrder(item: item)
        } else {
            orderController.addToOrder(item: item)
        }
        addOrRemoveFromOrderButtonText = getAddOrRemoveFromOrderButtonText(
            item: item,
            order: orderController.order
        )
    }
}

private func getAddOrRemoveFromOrderButtonText(item: MenuItem, order: Order) -> String {
    if (order.items.contains { $0 == item }) {
        return "Remove from order"
    } else {
        return "Add to order"
    }
}
