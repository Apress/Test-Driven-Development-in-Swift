import Combine

protocol MenuFetching {

    func fetchMenu() -> AnyPublisher<[MenuItem], Error>
}
