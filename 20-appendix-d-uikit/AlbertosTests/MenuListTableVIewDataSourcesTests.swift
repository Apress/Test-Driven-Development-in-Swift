import Testing
import UIKit
@testable import Albertos

@MainActor
class `MenuList TableView DataSource Tests` {

  @Test
  func `when loading with error, sections number is one`() {
    let dataSource = MenuListTableViewDataSource()
    let tableView = UITableView(frame: UIScreen.main.bounds)
    dataSource.setAsDataSourceOf(tableView)

    dataSource.reload(
      tableView,
      with: .failure(TestError(id: 1))
    )

    #expect(tableView.numberOfSections == 1)
  }

  @Test
  func `when loading with error, number of rows is one`() {
    let dataSource = MenuListTableViewDataSource()
    let tableView = UITableView(frame: UIScreen.main.bounds)
    dataSource.setAsDataSourceOf(tableView)

    dataSource.reload(
      tableView,
      with: .failure(TestError(id: 1))
    )

    #expect(tableView.numberOfRows(inSection: 0) == 1)
  }

  @Test
  func `when loading with error, cell text shows error`() {
    let dataSource = MenuListTableViewDataSource()
    let tableView = UITableView(frame: UIScreen.main.bounds)
    dataSource.setAsDataSourceOf(tableView)

    dataSource.reload(
      tableView,
      with: .failure(TestError(id: 1))
    )

    #expect(
      tableView.cellForRow(
        at: IndexPath(row: 0, section: 0)
      )?.textLabel?.text
      ==
      "An error occurred"
    )
  }

  @Test
  func `when loading with sections, number is input length`() {
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

    #expect(tableView.numberOfSections == 2)
  }

  @Test
  func `reads number of rows from items in sections`() {
    let dataSource = MenuListTableViewDataSource()
    let tableView = UITableView(frame: UIScreen.main.bounds)
    dataSource.setAsDataSourceOf(tableView)

    dataSource.reload(
      tableView,
      with: .success(
        [
          .fixture(items: [.fixture(), .fixture()]),
          .fixture(items: [.fixture()]),
          .fixture(items: [.fixture(), .fixture(), .fixture()]),
        ]
      )
    )

    #expect(tableView.numberOfRows(inSection: 0) == 2)
    #expect(tableView.numberOfRows(inSection: 1) == 1)
    #expect(tableView.numberOfRows(inSection: 2) == 3)
  }

  @Test
  func `when loading with sections, cell shows item name`() {
    let dataSource = MenuListTableViewDataSource()
    let tableView = UITableView(frame: UIScreen.main.bounds)
    dataSource.setAsDataSourceOf(tableView)

    dataSource.reload(
      tableView,
      with: .success(
        [
          .fixture(items: [.fixture(name: "a name")]),
          .fixture(items: [.fixture(name: "another name")])
        ]
      )
    )

    #expect(
      tableView.cellForRow(
        at: IndexPath(row: 0, section: 0)
      )?.textLabel?.text
      ==
      "a name"
    )
    #expect(
      tableView.cellForRow(
        at: IndexPath(row: 0, section: 1)
      )?.textLabel?.text
      ==
      "another name"
    )
  }
}
