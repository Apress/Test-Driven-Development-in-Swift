import Foundation

extension URLSession: NetworkFetching {

  func load(_ request: URLRequest) async throws -> Data {
    let (data, _) = try await data(for: request)
    return data
  }
}
