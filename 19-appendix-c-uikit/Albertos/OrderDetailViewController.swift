import Combine
import UIKit

protocol OrderDetailViewControllerDelegate: AnyObject {

    func orderDetailViewControllerCompletedPaymentFlow(_ viewController: OrderDetailViewController)
}

class OrderDetailViewController: UIViewController {

    lazy private var tableView = UITableView()
    lazy private var emptyMenuLabel = UILabel()
    lazy private var checkoutButton = BigButton()
    lazy private var totalPriceLabel = UITableViewFooterLabel()

    private let viewModel: OrderDetailViewModel

    weak var delegate: OrderDetailViewControllerDelegate?

    private var cancellables = Set<AnyCancellable>()

    init(orderController: OrderController, paymentProcessor: PaymentProcessing) {
        self.viewModel = OrderDetailViewModel(
            orderController: orderController,
            paymentProcessor: paymentProcessor,
            // Leaving this empty and relying on a navigation delegate, which is more UIKit-style
            onAlertDismiss: {}
        )
        super.init(nibName: .none, bundle: .none)
    }

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

        checkoutButton.addAction(
            UIAction(handler: { [weak self] _ in self?.viewModel.checkout() }),
            for: .primaryActionTriggered
        )

        viewModel.$alertToShow
            .compactMap { $0 }
            .map {
                return AlertViewModel(
                    title: $0.title,
                    message: $0.message,
                    buttonText: $0.buttonText,
                    buttonAction: $0.buttonAction
                )
            }
            .sink { [weak self] alertViewModel in
                self?.showAlert(with: alertViewModel)
            }
            .store(in: &cancellables)
    }

    private func configureViewLayout() {
        title = "Your Order"
        navigationController?.navigationBar.prefersLargeTitles = true

        view.backgroundColor = .systemBackground

        if viewModel.menuListItems.isEmpty {
            view.addSubview(emptyMenuLabel)
            emptyMenuLabel.pin([.leadingMargin, .trailingMargin], to: view, padding: 8)
            emptyMenuLabel.alignSafeAreaTopAnchor(to: view)
            emptyMenuLabel.text = viewModel.emptyMenuFallbackText
        } else {
            view.addSubview(tableView)
            tableView.fill(view)
            tableView.tableFooterView = totalPriceLabel
            // TODO: It would be better to use full Auto Layout with dynamic label height instead
            // of setting the frame manually.
            totalPriceLabel.frame = CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 40))

            view.addSubview(checkoutButton)
            checkoutButton.pin(.centerX, to: view)
            checkoutButton.alignSafeAreaBottomAnchor(to: view)

            totalPriceLabel.textAlignment = .center
            totalPriceLabel.text = viewModel.totalText
            if let fontDescriptor = totalPriceLabel.font.fontDescriptor.withSymbolicTraits(.traitItalic) {
                // size = 0 means "keep the current size"
                totalPriceLabel.font = UIFont(descriptor: fontDescriptor, size: 0)
            }

            tableView.dataSource = self
            tableView.delegate = self

            checkoutButton.setTitle("Checkout", for: .normal)
        }
    }

    private func showAlert(with viewModel: AlertViewModel) {
        let alert = UIAlertController(
            title: viewModel.title,
            message: viewModel.message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: viewModel.buttonText,
                style: .default,
                handler: { [weak self] _ in
                    viewModel.buttonAction?()
                    guard let self = self else { return }
                    self.delegate?.orderDetailViewControllerCompletedPaymentFlow(self)
                }
            )
        )

        present(alert, animated: true, completion: .none)
    }
}

extension OrderDetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.menuListItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: .none)

        let item = viewModel.menuListItems[indexPath.row]

        cell.textLabel?.text = item.name

        return cell
    }
}

extension OrderDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return .none
    }
}
