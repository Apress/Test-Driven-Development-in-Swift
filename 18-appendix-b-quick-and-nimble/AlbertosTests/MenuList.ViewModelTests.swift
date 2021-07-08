@testable import Albertos
import Combine
import Nimble
import XCTest

class MenuListViewModelTests: XCTestCase {

    var cancellables = Set<AnyCancellable>()

    func testWhenFetchingStartsPublishesEmptyMenu() throws {
        let viewModel = MenuList.ViewModel(menuFetching: MenuFetchingStub(returning: .success([])))

        let sections = try viewModel.sections.get()

        expect(sections).to(beEmpty())
        // This expectation is better than using `expect(sections.isEmpty) == true` because it fails
        // with:
        //
        // > expected to be empty, got <<value in the array>>
        //
        // Conversely, `expect(sections.isEmpty) == true` will fail with:
        //
        // > expected to equal <true>, got <false>
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
                expect(receivedMenu) == expectedMenu
                // Ensure the published value is the result of the grouping closure
                expect(sections) == expectedSections
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

                expect(error as? TestError) == expectedError
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }
}
