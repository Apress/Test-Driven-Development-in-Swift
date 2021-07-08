import Combine

extension OrderDetail {

    struct ViewModel {

        let headerText = "Your Order"
        let menuListItems: [MenuItem]
        let emptyMenuFallbackText = "Add dishes to the order to see them here"
        let totalText: String?

        init(orderController: OrderController) {
            totalText = orderController.order.items.isEmpty
                ? .none
                : "Total: $\(String(format: "%.2f", orderController.order.total))"

            menuListItems = orderController.order.items
        }
    }
}
