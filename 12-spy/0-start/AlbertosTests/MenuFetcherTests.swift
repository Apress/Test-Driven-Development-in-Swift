import Foundation
import Testing
@testable import Albertos

@MainActor
struct MenuFetcherTests {

  @Test
  func `when request ok returns menu items`() async throws {
    let json = """
[
  { "name": "n", "category": "c", "spicy": true, "price": 1.0 },
  { "name": "n2", "category": "c", "spicy": true, "price": 2.0 }
]
"""
    let data = try #require(json.data(using: .utf8))
    let networkFetchingStub = NetworkFetchingStub(
      returning: .success(data)
    )
    let menuFetcher = MenuFetcher(
      networkFetching: networkFetchingStub
    )

    let menu = try await menuFetcher.fetchMenu()

    #expect(menu.count == 2)
    #expect(menu.first?.name == "n")
    #expect(menu.last?.name == "n2")
  }

  @Test
  func `when request ko throws received error`() async throws {
    let expectedError = TestError(id: 1)
    let menuFetcher = MenuFetcher(
      networkFetching: NetworkFetchingStub(
        returning: .failure(expectedError)
      )
    )

    await #expect(throws: expectedError) {
      try await menuFetcher.fetchMenu()
    }
  }
}
