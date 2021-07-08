@testable import Albertos
import Combine
import Nimble
import XCTest

class MenuFetcherTests: XCTestCase {

    var cancellables = Set<AnyCancellable>()

    func testWhenRequestSucceedsPublishesDecodedMenuItems() throws {
        let json = """
[
    { "name": "a name", "category": "a category", "spicy": true, "price": 1.0 },
    { "name": "another name", "category": "a category", "spicy": true, "price": 2.0 }
]
"""
        let data = try XCTUnwrap(json.data(using: .utf8))
        let menuFetcher = MenuFetcher(networkFetching: NetworkFetchingStub(returning: .success(data)))

        waitUntil { done in
            menuFetcher.fetchMenu()
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { items in
                        expect(items).to(haveCount(2))
                        expect(items.first?.name) == "a name"
                        expect(items.last?.name) == "another name"
                        done()
                    }
                )
                .store(in: &self.cancellables)
        }
    }

    func testWhenRequestFailsPublishesReceivedError() {
        let expectedError = URLError(.badServerResponse)
        let menuFetcher = MenuFetcher(networkFetching: NetworkFetchingStub(returning: .failure(expectedError)))

        waitUntil { done in
            menuFetcher.fetchMenu()
                .sink(
                    receiveCompletion: { completion in
                        guard case .failure(let error) = completion else { return }
                        expect(error as? URLError) == expectedError
                        done()
                    },
                    receiveValue: { items in
                        XCTFail("Expected to fail, succeeded with \(items)")
                    }
                )
                .store(in: &self.cancellables)
        }
    }
}
