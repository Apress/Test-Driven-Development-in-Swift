import Combine

extension OrderButton {

    class ViewModel: ObservableObject {

        @Published private(set) var text = "Your Order"

        private(set) var cancellables = Set<AnyCancellable>()

        init(orderController: OrderController) {
            orderController.$order
                .sink { order in
                    self.text = order.items.isEmpty ? "Your Order" : "Your Order $\(String(format: "%.2f", order.total))"
                }
                .store(in: &cancellables)
        }
    }
}
