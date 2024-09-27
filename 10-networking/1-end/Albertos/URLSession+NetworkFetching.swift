import Combine
import Foundation

extension URLSession: NetworkFetching {
    func load(_ request: URLRequest) -> AnyPublisher<Data, URLError> {
        dataTaskPublisher(for: request)
            .map(\.data)
            .eraseToAnyPublisher()
    }
}
