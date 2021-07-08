@testable import Albertos
import XCTest

class MenuListTableViewDelegateTests: XCTestCase {

    func testWhenSectionsIsFailureDoesNotCallSelectionCallback() {
        var called = false
        let delegate = MenuListTableViewDelegate(onRowSelected: { _ in called = true })
        delegate.sections = .failure(TestError(id: 1))

        delegate.tableView(UITableView(), didSelectRowAt: IndexPath(row: 0, section: 0))

        XCTAssertFalse(called)
    }

    func testWhenSectionsIsSuccessCallSelectionCallbackWithMatchingItem() {
        var receivedItem: MenuItem?
        let delegate = MenuListTableViewDelegate(onRowSelected: { receivedItem = $0 })
        let item = MenuItem.fixture(name: "a name")
        delegate.sections = .success([.fixture(items: [.fixture(name: "another name"), item])])

        delegate.tableView(UITableView(), didSelectRowAt: IndexPath(row: 1, section: 0))

        XCTAssertEqual(receivedItem, item)
    }
}
