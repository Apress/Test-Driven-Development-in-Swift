@testable import Albertos
import Combine
import XCTest

class MenuListViewModelTests: XCTestCase {

    var cancellables = Set<AnyCancellable>()

    func testWhenFetchingStartsPublishesEmptyMenu() throws {
        let viewModel = MenuList.ViewModel(menuFetching: MenuFetchingPlaceholder())

        XCTAssertTrue(try viewModel.sections.get().isEmpty)
    }

    func testWhenFecthingSucceedsPublishesSectionsBuiltFromReceivedMenuAndGivenGroupingClosure() {
        var receivedMenu: [MenuItem]?
        let expectedSections = [MenuSection.fixture()]
        let spyClosure: ([MenuItem]) -> [MenuSection] = { items in receivedMenu = items
            return expectedSections
        }

        let expectedMenu = [MenuItem.fixture()]
        let menuFetchingStub = MenuFetchingStub(returning: .success(expectedMenu))

        let viewModel = MenuList.ViewModel(menuFetching: menuFetchingStub, menuGrouping: spyClosure)

        let expectation = XCTestExpectation(
            description: "Publishes sections built from received menu and given grouping closure"
        )
        viewModel
            .$sections
            .dropFirst()
            .sink { value in
                guard case .success(let sections) = value else {
                    return XCTFail("Expected a successful Result, got: \(value)")
                }

                // Ensure the grouping closure is called with the received menu
                XCTAssertEqual(receivedMenu, expectedMenu)
                // Ensure the published value is the result of the grouping closure
                XCTAssertEqual(sections, expectedSections)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    func testWhenFetchingFailsPublishesAnError() {
        let expectedError = TestError(id: 123)
        let menuFetchingStub = MenuFetchingStub(returning: .failure(expectedError))
        let viewModel = MenuList.ViewModel(
            menuFetching: menuFetchingStub,
            menuGrouping: { _ in [] }
        )

        let expectation = XCTestExpectation(description: "Publishes an error")

        viewModel
            .$sections
            .dropFirst()
            .sink { value in
                guard case .failure(let error) = value else {
                    return XCTFail("Expected a failing Result, got: \(value)")
                }

                XCTAssertEqual(error as? TestError, expectedError)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }
}
