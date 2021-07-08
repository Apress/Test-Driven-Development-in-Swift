import UIKit

class MenuItemDetailViewController: UIViewController {

    let containerView = MenuItemDetailView()

    private let viewModel: MenuItemDetailViewModel

    init(viewModel: MenuItemDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: .none, bundle: .none)
    }

    // MARK: - Make other inits unavailable

    @available(*, unavailable, message: "Use `init(item:, orderController:)` instead")
    init() {
        fatalError("This view controller has no `.xib` backing it. Use `init` instead.")
    }

    @available(*, unavailable, message: "Use `init` instead")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("This view controller has no `.xib` backing it. Use `init` instead.")
    }

    @available(*, unavailable, message: "Use `init` instead")
    required init?(coder: NSCoder) {
        fatalError("This view controller has no `.xib` backing it. Use `init` instead.")
    }

    // MARK: - View life-cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewLayout()

        containerView.configureContent(with: viewModel)

        containerView.addOrRemoveFromOrderButton.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self = self else { return }
                    self.viewModel.addOrRemoveFromOrder()
                    self.containerView.configureContent(with: self.viewModel)
                }
            ),
            for: .primaryActionTriggered
        )
    }

    // MARK: -

    private func configureViewLayout() {
        view.backgroundColor = .systemBackground

        // Use this to show the navigation bar
//        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(containerView)
        containerView.pin([.topMargin, .leftMargin, .rightMargin], to: view)
        containerView.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
