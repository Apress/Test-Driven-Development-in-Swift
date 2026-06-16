import Foundation

class MenuFetchingPlaceholder: MenuFetching {

  private let menu: [MenuItem]

  init(menu: [MenuItem] = Albertos.menu) {
    self.menu = menu
  }

  func fetchMenu() async throws -> [MenuItem] {
    try await Task.sleep(for: .milliseconds(500))
    return menu
  }
}
