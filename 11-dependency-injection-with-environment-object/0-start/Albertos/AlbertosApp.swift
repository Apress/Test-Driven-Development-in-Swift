import SwiftUI

@main
struct AlbertosApp: App {
  var body: some Scene {
    WindowGroup {
      ZStack(alignment: .bottom) {
        NavigationStack {
          MenuList(
            viewModel: .init(menuFetching: MenuFetcher())
          )
          .navigationTitle("Alberto's 🇮🇹")
        }
        OrderButton()
          .padding(6)
      }
    }
  }
}
