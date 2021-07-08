import UIKit

class MenuListTableViewDelegate: NSObject, UITableViewDelegate {

    var sections: Result<[MenuSection], Error> = .success([])

    let onRowSelected: (MenuItem) -> ()

    init(onRowSelected: @escaping (MenuItem) -> ()) {
        self.onRowSelected = onRowSelected
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard case .success(let sections) = sections else { return }

        let item = sections[indexPath.section].items[indexPath.row]

        onRowSelected(item)
    }
}
