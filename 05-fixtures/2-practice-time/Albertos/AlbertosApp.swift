import SwiftUI

@main
struct AlbertosApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        MenuList(sections: groupMenuByCategory(menu))
          .navigationTitle("Alberto's 🇮🇹")
      }
    }
  }
}
