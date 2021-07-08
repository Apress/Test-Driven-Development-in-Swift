import Combine
import UIKit

class AppCoordinator: MenuListViewControllerNavigationDelegate, OrderDetailViewControllerDelegate {

    let navigationController: UINavigationController
    private let orderController: OrderController
    private let paymentProcessing: PaymentProcessing

    private lazy var menuListViewController: MenuListViewController = {
        let viewController = MenuListViewController(menuFetching: MenuFetcher())
        viewController.navigationDelegate = self
        return viewController
    }()

    private let orderButton: UIButton

    private lazy var orderButtonViewModel = OrderButtonViewModel(orderController: orderController)

    private var cancellables = Set<AnyCancellable>()

    init(
        orderController: OrderController,
        paymentProcessing: PaymentProcessing,
        navigationController: UINavigationController = UINavigationController()
    ) {
        self.navigationController = navigationController
        self.orderController = orderController
        self.paymentProcessing = paymentProcessing

        orderButton = BigButton() // a `UIButton` subclass that configures the button style

        orderButtonViewModel.$text
            .sink { [weak self] text in
                guard let button = self?.orderButton else { return }
                button.setTitle(text, for: .normal)
            }
            .store(in: &cancellables)

        orderButton.addAction(
            UIAction(handler: { [weak self] _ in self?.presentOrderDetail()}),
            for: .primaryActionTriggered
        )
    }

    func loadFirstScreen() {
        navigationController.viewControllers = [menuListViewController]

        navigationController.view.addSubview(orderButton)

        orderButton.pin(.centerX, to: navigationController.view)
        orderButton.alignSafeAreaBottomAnchor(to: navigationController.view)
    }

    func orderDetailViewControllerCompletedPaymentFlow(_ viewController: OrderDetailViewController) {
        navigationController.dismiss(animated: true, completion: .none)
    }

    func menuListViewController(
        _ viewController: MenuListViewController,
        didSelectItem item: MenuItem
    ) {
        navigationController.pushViewController(
            MenuItemDetailViewController(
                viewModel: .init(item: item, orderController: orderController)
            ),
            animated: true
        )
    }

    func presentOrderDetail() {
        let orderDetailViewController =  OrderDetailViewController(
            orderController: orderController,
            paymentProcessor: paymentProcessing
        )
        orderDetailViewController.delegate = self

        navigationController.present(
            UINavigationController(rootViewController: orderDetailViewController),
            animated: true,
            completion: .none
        )
    }
}
