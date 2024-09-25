import SwiftUI

@main
struct AlbertosApp: App {

    var body: some Scene {
        WindowGroup {
            NavigationView {
                MenuList(viewModel: .init(menuFetching: MenuFetchingPlaceholder()))
                    .navigationTitle("Alberto's 🇮🇹")
            }
        }
    }
}
