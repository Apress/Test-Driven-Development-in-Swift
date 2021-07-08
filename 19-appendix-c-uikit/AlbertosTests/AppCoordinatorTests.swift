@testable import Albertos
import Nimble
import XCTest

class AppCoordinatorTests: XCTestCase {

    func testInitialViewControllerIsNavigationWithMenuList() throws {
        let navigationController = UINavigationController()
        let coordinator = makeAppCoordinator(with: navigationController)

        coordinator.loadFirstScreen()

        XCTAssertTrue(navigationController.viewControllers.first is MenuListViewController)
    }

    func testPushesMenuDetailsOnNavigationStack() {
        let navigationController = UINavigationController()
        let coordinator = makeAppCoordinator(
            with: navigationController
        )
        let dummyMenuListVC = MenuListViewController(
            menuFetching: MenuFetchingStub(
                returning: .success([])
            )
        )
        let item = MenuItem.fixture()

        coordinator.menuListViewController(
            dummyMenuListVC,
            didSelectItem: item
        )
        expect(navigationController.viewControllers.first)
            .toEventually(
                beAKindOf(MenuItemDetailViewController.self)
            )
    }

    func testPresentsOrderDetailOnTopOfNavigationStack() {
        let navigationController = UINavigationController()
        let coordinator = makeAppCoordinator(with: navigationController)

        // For modal presentation to work, UIKit needs the presenter view controller to be "on
        // screen". That's not the case with this `AppCoordinator` instance, because we instantiate
        // it outside of the standard application flow. To work around that, let's put the root VC
        // in a dedicated window.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = navigationController

        expect(navigationController.presentedViewController).to(beNil())

        coordinator.presentOrderDetail()

        // Using `.toEventually` to take animations into account.
        // You could refine the setup and inject an `animated` parameter either at the method or
        // `AppCoordinator` `init` level, and set it `false` here to avoid that. Set the parameter
        // default value `true` to make it seamless in the production code.
        expect(navigationController.presentedViewController)
            .toEventually(beAKindOf(UINavigationController.self))

        let presentedNavigationController =
            navigationController.presentedViewController as? UINavigationController

        expect(presentedNavigationController?.viewControllers.first)
            .to(beAKindOf(OrderDetailViewController.self))
    }

    func testDismissesPresentedVCOnOrderCompletion() {
        let navigationController = UINavigationController()
        let coordinator = makeAppCoordinator(with: navigationController)

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = navigationController

        expect(navigationController.presentedViewController).to(beNil())

        navigationController.present(UIViewController(), animated: false, completion: .none)

        expect(navigationController.presentedViewController).toNot(beNil())

        let dummyOrderDetailVC = OrderDetailViewController(
            orderController: OrderController(orderStoring: OrderStoringFake()),
            paymentProcessor: PaymentProcessingDummy()
        )
        coordinator.orderDetailViewControllerCompletedPaymentFlow(dummyOrderDetailVC)

        expect(navigationController.presentedViewController).toEventually(beNil())
    }

    private func makeAppCoordinator(with navigationController: UINavigationController) -> AppCoordinator {
        return AppCoordinator(
            orderController: OrderController(orderStoring: OrderStoringFake()),
            paymentProcessing: PaymentProcessingDummy(),
            navigationController: navigationController
        )
    }
}
