import SwiftUI

@main
struct AlbertosApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        MenuList(viewModel: .init(menuFetching: MenuFetcher()))
          .navigationTitle("Alberto's 🇮🇹")
      }
    }
  }
}
