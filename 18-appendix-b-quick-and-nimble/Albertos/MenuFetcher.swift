import Combine
import Foundation

class MenuFetcher: MenuFetching {

    let networkFetching: NetworkFetching

    init(networkFetching: NetworkFetching = URLSession.shared) {
        self.networkFetching = networkFetching
    }

    func fetchMenu() -> AnyPublisher<[MenuItem], Error> {
        return networkFetching.load(URLRequest(url: URL(string: "https://s3.amazonaws.com/mokacoding/menu_response.json")!))
            .decode(type: [MenuItem].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
