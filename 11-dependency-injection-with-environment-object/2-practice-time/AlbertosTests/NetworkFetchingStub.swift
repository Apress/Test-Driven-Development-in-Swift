import Foundation
@testable import Albertos

struct NetworkFetchingStub: NetworkFetching {

  private let result: Result<Data, Error>

  init(returning result: Result<Data, Error>) {
    self.result = result
  }

  func load(_ request: URLRequest) async throws -> Data {
    // Sleep to emulate the real world async behavior
    try await Task.sleep(for: .milliseconds(100))
    switch result {
    case .success(let data): return data
    case .failure(let error): throw error
    }
  }
}
