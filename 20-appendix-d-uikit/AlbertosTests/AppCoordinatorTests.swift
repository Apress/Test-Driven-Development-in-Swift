import Testing
import UIKit
@testable import Albertos

@MainActor
class `AppCoordinator Tests` {

  @Test
  func `initial ViewController is navigation with menu list`() {
    let navigationController = UINavigationController()
    let coordinator = makeAppCoordinator(
      with: navigationController
    )

    coordinator.loadFirstScreen()

    #expect(
      navigationController
        .viewControllers
        .first is MenuListViewController
    )
  }

  @Test
  func `pushes menu details on navigation stack`() {
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

    #expect(
      navigationController.viewControllers.first
      is MenuItemDetailViewController
    )
  }

  @Test
  func `presents order detail on top of navigation stack`() {
    let navigationController = UINavigationController()
    let coordinator = makeAppCoordinator(
      with: navigationController
    )

    // For modal presentation to work, UIKit needs the presenter
    // view controller to be "on screen".
    // That's not the case with this `AppCoordinator` instance,
    // because we instantiate it outside of the standard
    // application flow.
    // To work around that, let's put the root VC in a dedicated
    // window.
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.makeKeyAndVisible()
    window.rootViewController = navigationController

    // Confidence check that nothing is currently presented.
    #expect(navigationController.presentedViewController == nil)

    coordinator.presentOrderDetail()

    // Verify that the coordinator presented a navigation stack
    #expect(
      navigationController.presentedViewController
      is UINavigationController
    )

    // ...configured with the order detail screen on top
    let presentedNavigationController =
    navigationController.presentedViewController
      as? UINavigationController

    #expect(
      presentedNavigationController?.viewControllers.first
      is OrderDetailViewController
    )
  }

  @Test
  func `dismisses on order completion`() async throws {
    let navigationController = UINavigationController()
    let coordinator = makeAppCoordinator(
      with: navigationController
    )

    let window = UIWindow(frame: UIScreen.main.bounds)
    window.makeKeyAndVisible()
    window.rootViewController = navigationController

    // Confidence check that the navigation controller has
    // not presented anything yet.
    #expect(navigationController.presentedViewController == nil)

    // Make the navigation controller present a dummy
    // ViewController to represent the order flow.
    navigationController.present(
      UIViewController(),
      animated: false,
      completion: .none
    )

    // Confidence check that a view controller is now presented.
    #expect(navigationController.presentedViewController != nil)

    // We need an OrderDetailViewController instance to pass
    // to the coordinator completion method.
    let dummyOrderDetailVC = OrderDetailViewController(
      orderController: OrderController(
        orderStoring: OrderStoringFake()
      ),
      paymentProcessor: PaymentProcessingDummy()
    )
    coordinator.orderDetailViewControllerCompletedPaymentFlow(
      dummyOrderDetailVC
    )

    // Rare instance where it's acceptable to sleep during unit
    // tests!
    //
    // Even though animations are disabled, it still takes time
    // for the UINavigationController to dismiss the
    // presented view controller.
    try await Task.sleep(nanoseconds: 50_000_000)

    #expect(navigationController.presentedViewController == nil)
  }

  func makeAppCoordinator(
    with navigationController: UINavigationController
  ) -> AppCoordinator {
    return AppCoordinator(
      orderController: OrderController(
        orderStoring: OrderStoringFake()
      ),
      paymentProcessing: PaymentProcessingDummy(),
      navigationController: navigationController,
      uiAnimationsEnabled: false
    )
  }
}
