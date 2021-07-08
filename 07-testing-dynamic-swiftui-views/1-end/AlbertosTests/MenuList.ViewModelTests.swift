@testable import Albertos
import Combine
import XCTest

class MenuListViewModelTests: XCTestCase {

    var cancellables = Set<AnyCancellable>()

    func testWhenFetchingStartsPublishesEmptyMenu() {
        let viewModel = MenuList.ViewModel(menuFetching: MenuFetchingPlaceholder())

        XCTAssertTrue(viewModel.sections.isEmpty)
    }

    func testWhenFecthingSucceedsPublishesSectionsBuiltFromReceivedMenuAndGivenGroupingClosure() {
        var receivedMenu: [MenuItem]?
        let expectedSections = [MenuSection.fixture()]

        let spyClosure: ([MenuItem]) -> [MenuSection] = { items in receivedMenu = items
            return expectedSections
        }
        let viewModel = MenuList.ViewModel(
            menuFetching: MenuFetchingPlaceholder(),
            menuGrouping: spyClosure
        )
        let expectation = XCTestExpectation(
            description: "Publishes sections built from received menu and given grouping closure"
        )
        viewModel
            .$sections
            .dropFirst()
            .sink { value in
                // Ensure the grouping closure is called with the received menu
                XCTAssertEqual(receivedMenu, menu)
                // Ensure the published value is the result of the grouping closure
                XCTAssertEqual(value, expectedSections)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    func testWhenFetchingFailsPublishesAnError() {}
}
