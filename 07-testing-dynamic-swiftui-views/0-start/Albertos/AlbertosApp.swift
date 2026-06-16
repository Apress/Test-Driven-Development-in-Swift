import SwiftUI

@main
struct AlbertosApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        MenuList(viewModel: .init(menu: menu))
          .navigationTitle("Alberto's 🇮🇹")
      }
    }
  }
}
