@testable import Albertos
import Combine
import Foundation

class NetworkFetchingStub: NetworkFetching {

    private let result: Result<Data, URLError>

    init(returning result: Result<Data, URLError>) {
        self.result = result
    }

    func load(_ request: URLRequest) -> AnyPublisher<Data, URLError> {
        return result.publisher
            // Use a delay to simulate the real world async behavior
            .delay(for: 0.01, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
