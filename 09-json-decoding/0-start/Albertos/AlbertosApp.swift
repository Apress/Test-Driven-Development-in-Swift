import SwiftUI

@main
struct AlbertosApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        MenuList(
          viewModel: .init(
            menuFetching: MenuFetchingPlaceholder()
          )
        )
          .navigationTitle("Alberto's 🇮🇹")
      }
    }
  }
}
