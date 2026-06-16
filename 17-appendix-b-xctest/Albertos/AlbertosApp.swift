import SwiftUI

@main
struct AlbertosApp: App {

  let orderController = OrderController()

  var body: some Scene {
    WindowGroup {
      ZStack(alignment: .bottom) {
        NavigationStack {
          MenuList(
            viewModel: .init(menuFetching: MenuFetcher())
          )
          .navigationTitle("Alberto's 🇮🇹")
        }
        OrderButton(
          viewModel: .init(orderController: orderController)
        )
        .padding(6)
      }
    }
    .environmentObject(orderController)
  }
}
