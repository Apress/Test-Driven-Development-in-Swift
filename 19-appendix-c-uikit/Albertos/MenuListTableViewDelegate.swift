import UIKit

class MenuListTableViewDelegate: NSObject, UITableViewDelegate {
    var sections: Result<[MenuSection], Error> = .success([])

    let onRowSelected: (MenuItem) -> Void

    init(onRowSelected: @escaping (MenuItem) -> Void) {
        self.onRowSelected = onRowSelected
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard case let .success(sections) = sections else { return }

        let item = sections[indexPath.section].items[indexPath.row]

        onRowSelected(item)
    }
}
