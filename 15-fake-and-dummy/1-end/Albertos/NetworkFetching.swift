import Combine
import Foundation

protocol NetworkFetching {

    func load(_ request: URLRequest) -> AnyPublisher<Data, URLError>
}
