import Combine
import UIKit

protocol MenuListViewControllerNavigationDelegate: AnyObject {

    func menuListViewController(
        _ viewController: MenuListViewController,
        didSelectItem item: MenuItem
    )
}

class MenuListViewController: UIViewController {

    let tableView = UITableView()

    weak var navigationDelegate: MenuListViewControllerNavigationDelegate?

    let viewModel: MenuListViewModel

    lazy private var tableViewDataSource = MenuListTableViewDataSource()
    lazy private var tableViewDelegate = MenuListTableViewDelegate(
        onRowSelected: { [weak self] in
            guard let self = self else { return }
            self.navigationDelegate?.menuListViewController(self, didSelectItem: $0)
        }
    )

    private var cancellables = Set<AnyCancellable>()

    init(menuFetching: MenuFetching) {
        self.viewModel = MenuListViewModel(menuFetching: menuFetching)
        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable, message: "Use `init` instead")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("This view controller has no `.xib` backing it. Use `init` instead.")
    }

    @available(*, unavailable, message: "Use `init` instead")
    required init?(coder: NSCoder) {
        fatalError("This view controller has no `.xib` backing it. Use `init` instead.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewLayout()

        tableViewDataSource.setAsDataSourceOf(tableView)
        tableView.delegate = tableViewDelegate

        viewModel.$sections
            .receive(on: RunLoop.main)
            .sink { [weak self] sections in
                guard let self = self else { return }

                self.tableViewDataSource.reload(self.tableView, with: sections)
                self.tableViewDelegate.sections = sections
            }
            .store(in: &cancellables)
    }

    private func configureViewLayout() {
        title = "Albertos 🇮🇹"
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(tableView)
        tableView.fill(view)
        // Don't show empty cells if there are less items that what would fill the screen
        tableView.tableFooterView = UIView()
    }
}
