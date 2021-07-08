//@testable import Albertos
//import Nimble
//import XCTest
//
//class SceneDelegateTests: XCTestCase {
//
//    // TODO: Need better name
//    func testShowsMenuDetailViewControllerOnNavigationStack() {
//        let sceneDelegate = SceneDelegate()
//        let dummyMenuListVC = MenuListViewController(menuFetching: MenuFetchingStub(returning: .success([])))
//        let item = MenuItem.fixture()
//
//        sceneDelegate.menuListViewController(dummyMenuListVC, didSelectItem: item)
//
//        // Using `.toEventually` to take animations into account.
//        // You could refine the setup and inject an `animated` parameter either at the method or
//        // `SceneDelegate` `init` level, and set it `false` here to avoid that. Set the parameter
//        // default value `true` to make it seamless in the production code.
//        expect(sceneDelegate.navigationController.viewControllers.first)
//            .toEventually(beAKindOf(MenuItemDetailViewController.self))
//    }
//
//    // TODO: Need better name
//    func testPresentsOrderDetailOnTopOfNavigationStack() {
//        let sceneDelegate = SceneDelegate()
//
//        // For modal presentation to work, UIKit needs the presenter view controller to be "on
//        // screen". That's not the case with this `SceneDelegate` instance, because we do not call
//        // the `scene(_:, willConnectTo:, options:)` method. To work around that, let's put the
//        // `SceneDelegate` root VC in a dedicated window.
//        //
//        // An alternative approach would be using DIP and having an abstraction layer to describe a
//        // component capable of modally presenting view controllers. E.g.:
//        //
//        // ```
//        // protocol ViewControllerPresenting {
//        //     func present(_ viewController: UIViewController, animated: Bool, ...)
//        // }
//        // ```
//        //
//        // We could then build a spy test double and use it to verify the presented VC. That would
//        // make the tests faster and less dependent on finicky UIKit requirements.
//        let window = UIWindow(frame: UIScreen.main.bounds)
//        window.makeKeyAndVisible()
//        window.rootViewController = sceneDelegate.navigationController
//        // This is also required, it loads the navigation controller view.
//        _ = sceneDelegate.navigationController.view
//
//        expect(sceneDelegate.navigationController.presentedViewController).to(beNil())
//
//        sceneDelegate.presentOrderDetail()
//
//        // Using `.toEventually` to take animations into account.
//        // You could refine the setup and inject an `animated` parameter either at the method or
//        // `SceneDelegate` `init` level, and set it `false` here to avoid that. Set the parameter
//        // default value `true` to make it seamless in the production code.
//        expect(sceneDelegate.navigationController.presentedViewController)
//            .toEventually(beAKindOf(UINavigationController.self))
//
//        let presentedNavigationController =
//            sceneDelegate.navigationController.presentedViewController as? UINavigationController
//
//        expect(presentedNavigationController?.viewControllers.first)
//            .to(beAKindOf(OrderDetailViewController.self))
//    }
//
//    // TODO: Need better name
//    func testDismissesPresentedVCOnOrderCompletion() {
//        let sceneDelegate = SceneDelegate()
//
//        let window = UIWindow(frame: UIScreen.main.bounds)
//        window.makeKeyAndVisible()
//        window.rootViewController = sceneDelegate.navigationController
//        _ = sceneDelegate.navigationController.view
//
//        expect(sceneDelegate.navigationController.presentedViewController).to(beNil())
//
//        sceneDelegate.navigationController.present(UIViewController(), animated: false, completion: .none)
//
//        expect(sceneDelegate.navigationController.presentedViewController).toNot(beNil())
//
//        let dummyOrderDetailVC = OrderDetailViewController(
//            orderController: OrderController(orderStoring: OrderStoringFake()),
//            paymentProcessor: PaymentProcessingDummy()
//        )
//        sceneDelegate.orderDetailViewControllerCompletedPaymentFlow(dummyOrderDetailVC)
//
//        expect(sceneDelegate.navigationController.presentedViewController).toEventually(beNil())
//    }
//}
