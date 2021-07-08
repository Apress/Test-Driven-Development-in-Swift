import Combine
import Foundation

class MenuFetchingPlaceholder: MenuFetching {
    func fetchMenu() -> AnyPublisher<[MenuItem], Error> {
        return Future { $0(.success(menu)) }
            // Use a delay to simulate async fetch
            .delay(for: 0.5, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
