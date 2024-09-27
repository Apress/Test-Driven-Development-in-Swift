import UIKit

class MenuListTableViewDataSource: NSObject, UITableViewDataSource {
    private var sections: Result<[MenuSection], Error>
    private let cellIdentifier = "cell"

    init(initialSections sections: Result<[MenuSection], Error> = .success([])) {
        self.sections = sections
        super.init()
    }

    func setAsDataSourceOf(_ tableView: UITableView) {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    func reload(_ tableView: UITableView, with sections: Result<[MenuSection], Error>) {
        self.sections = sections
        tableView.reloadData()
    }

    func numberOfSections(in _: UITableView) -> Int {
        guard case let .success(sections) = sections else { return 1 }
        return sections.count
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard case let .success(sections) = sections else { return .none }
        return sections[safe: section]?.category.uppercased()
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case let .success(sections) = sections else { return 1 }
        return sections[safe: section]?.items.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        switch sections {
        case let .failure(error):
            cell.textLabel?.text = "An error occurred"
            cell.detailTextLabel?.text = "\(error.localizedDescription)"
        case let .success(sections):
            guard let item = sections[safe: indexPath.section]?.items[safe: indexPath.row] else {
                return cell
            }
            let viewModel = MenuRowViewModel(item: item)
            cell.textLabel?.text = viewModel.text
            cell.accessoryType = .disclosureIndicator
        }

        return cell
    }
}
