import Combine
import HippoPayments
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let orderController = OrderController()
    let paymentProcessing = HippoPaymentsProcessor(apiKey: "ABC")

    let orderButton = BigButton()
    lazy var orderButtonViewModel = OrderButtonViewModel(orderController: orderController)
    private var cancellables = Set<AnyCancellable>()

    lazy var coordinator = AppCoordinator(
        orderController: orderController,
        paymentProcessing: paymentProcessing
    )

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard NSClassFromString("XCTestCase") == nil else { return }

        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = coordinator.navigationController
        self.window = window
        window.makeKeyAndVisible()

        coordinator.loadFirstScreen()
    }
}
