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

    private lazy var tableViewDataSource = MenuListTableViewDataSource()
    private lazy var tableViewDelegate = MenuListTableViewDelegate(
        onRowSelected: { [weak self] in
            guard let self else { return }
            navigationDelegate?.menuListViewController(self, didSelectItem: $0)
        }
    )

    private var cancellables = Set<AnyCancellable>()

    init(menuFetching: MenuFetching) {
        viewModel = MenuListViewModel(menuFetching: menuFetching)
        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable, message: "Use `init` instead")
    override init(nibName _: String?, bundle _: Bundle?) {
        fatalError("This view controller has no `.xib` backing it. Use `init` instead.")
    }

    @available(*, unavailable, message: "Use `init` instead")
    required init?(coder _: NSCoder) {
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
                guard let self else { return }

                tableViewDataSource.reload(tableView, with: sections)
                tableViewDelegate.sections = sections
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
