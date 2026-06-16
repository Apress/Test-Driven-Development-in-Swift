@testable import Albertos
import Foundation

class MenuFetchingStub: MenuFetching {

  let result: Result<[MenuItem], Error>

  init(returning result: Result<[MenuItem], Error>) {
    self.result = result
  }

  func fetchMenu() async throws -> [MenuItem] {
    // Sleep to emulate the real world async behavior
    try await Task.sleep(for: .milliseconds(100))
    switch result {
    case .success(let menu): return menu
    case .failure(let error): throw error
    }
  }
}
