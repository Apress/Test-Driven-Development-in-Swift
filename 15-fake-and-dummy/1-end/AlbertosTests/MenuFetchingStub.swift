@testable import Albertos
import Combine
import Foundation

class MenuFetchingStub: MenuFetching {

    let result: Result<[MenuItem], Error>

    init(returning result: Result<[MenuItem], Error>) {
        self.result = result
    }

    func fetchMenu() -> AnyPublisher<[MenuItem], Error> {
        return result.publisher
            // Use a delay to simulate the real world async behavior
            .delay(for: 0.1, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
