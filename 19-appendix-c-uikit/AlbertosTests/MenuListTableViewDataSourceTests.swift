@testable import Albertos
import XCTest

class MenuListTableViewDataSourceTests: XCTestCase {

    func testWhenViewModelSectionsIsErrorSectionNumberIsOne() {
        let dataSource = MenuListTableViewDataSource()
        let tableView = UITableView(frame: UIScreen.main.bounds)
        dataSource.setAsDataSourceOf(tableView)

        dataSource.reload(tableView, with: .failure(TestError(id: 1)))

        XCTAssertEqual(tableView.numberOfSections, 1)
    }

    func testWhenViewModelSectionsIsSuccessSectionNumberIsNumberOfSections() {
        let dataSource = MenuListTableViewDataSource()
        let tableView = UITableView(frame: UIScreen.main.bounds)
        dataSource.setAsDataSourceOf(tableView)

        dataSource.reload(
            tableView,
            with: .success(
                [
                    .fixture(category: "a category"),
                    .fixture(category: "another category")
                ]
            )
        )

        XCTAssertEqual(tableView.numberOfSections, 2)
    }

    func testWhenViewModelSectionsIsErrorNumberOfRowsInSectionIsOne() {
        let dataSource = MenuListTableViewDataSource()
        let tableView = UITableView(frame: UIScreen.main.bounds)
        dataSource.setAsDataSourceOf(tableView)

        dataSource.reload(tableView, with: .failure(TestError(id: 1)))

        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
    }

    func testWhenViewModelSectionsIsSuccessNumberOfRowsInSectionIsSectionItemsCount() {
        let dataSource = MenuListTableViewDataSource()
        let tableView = UITableView(frame: UIScreen.main.bounds)
        dataSource.setAsDataSourceOf(tableView)

        dataSource.reload(tableView, with: .success([.fixture(items: [.fixture(), .fixture()])]))

        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }

    func testWhenViewModelSectionsIsErrorCellTextShowsError() {
        let dataSource = MenuListTableViewDataSource()
        let tableView = UITableView(frame: UIScreen.main.bounds)
        dataSource.setAsDataSourceOf(tableView)

        dataSource.reload(tableView, with: .failure(TestError(id: 1)))

        XCTAssertEqual(
            tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.textLabel?.text,
            "An error occurred"
        )
    }

    func testWhenViewModelSectionsIsSuccessCellShowsItemName() {
        let dataSource = MenuListTableViewDataSource()
        let tableView = UITableView(frame: UIScreen.main.bounds)
        dataSource.setAsDataSourceOf(tableView)

        dataSource.reload(tableView, with: .success([.fixture(items: [.fixture(name: "a name")])]))

        XCTAssertEqual(
            tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.textLabel?.text,
            "a name"
        )
    }
}
