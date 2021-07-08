@testable import Albertos
import Nimble
import XCTest

class MenuListViewControllerTests: XCTestCase {

    func testWhenNewDataArrivesUpdatesTableView() {
        let vc = MenuListViewController(
            menuFetching: MenuFetchingStub(returning: .success([.fixture(name: "a name")]))
        )
        _ = vc.view
        // UITableView only loads cells if they are visible, so we need to force the
        // ViewController's view to be big enough for the cell we're inspecting to be rendered.
        vc.view.layoutIfNeeded()

        expect(vc.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.textLabel?.text)
            .to(beNil())

        expect(vc.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.textLabel?.text)
            .toEventually(equal("a name"))
    }
}
