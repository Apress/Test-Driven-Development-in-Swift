import Foundation

protocol NetworkFetching {

  func load(_ request: URLRequest) async throws -> Data
}
