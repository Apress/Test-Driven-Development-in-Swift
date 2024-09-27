import SwiftUI

@main
struct AlbertosApp: App {
    let orderController = OrderController()
    let paymentProcessor = PaymentProcessingProxy()

    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .bottom) {
                NavigationView {
                    MenuList(viewModel: .init(menuFetching: MenuFetcher()))
                        .navigationTitle("Alberto's 🇮🇹")
                }
                OrderButton(viewModel: .init(orderController: orderController))
                    .padding(6)
            }
            .environmentObject(orderController)
            .environmentObject(paymentProcessor)
        }
    }
}
