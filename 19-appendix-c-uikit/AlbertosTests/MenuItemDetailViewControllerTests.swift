@testable import Albertos
import XCTest

class MenuItemDetailViewControllerTests: XCTestCase {

    func testConfiguresViewWithViewModel() {
        let viewModel = MenuItemDetailViewModel(
            item: MenuItem.fixture(),
            orderController: OrderController(orderStoring: OrderStoringFake())
        )
        let viewController = MenuItemDetailViewController(viewModel: viewModel)
        _ = viewController.view

        XCTAssertEqual(viewController.containerView.nameLabel.text, viewModel.name)
        XCTAssertEqual(viewController.containerView.priceLabel.text, viewModel.price)
        XCTAssertEqual(
            viewController.containerView.addOrRemoveFromOrderButton.title(for: .normal),
            viewModel.addOrRemoveFromOrderButtonText
        )
        XCTAssertEqual(viewController.containerView.spicyLabel.text, viewModel.spicy)
    }

    func testUpdatesOrderWhenButtonActioned() {
        let item = MenuItem.fixture()
        let orderController = OrderController(orderStoring: OrderStoringFake())
        let viewController = MenuItemDetailViewController(
            viewModel: .init(item: item, orderController: orderController)
        )
        _ = viewController.view

        viewController.containerView.addOrRemoveFromOrderButton.sendActions(for: .touchUpInside)

        XCTAssertTrue(orderController.order.items.contains(item))

        viewController.containerView.addOrRemoveFromOrderButton.sendActions(for: .touchUpInside)

        XCTAssertFalse(orderController.order.items.contains(item))
    }

    func testUpdatesViewAfterButtonActioned() {
        let item = MenuItem.fixture()
        let orderController = OrderController(orderStoring: OrderStoringFake())
        let menuItemDetailVC = MenuItemDetailViewController(
            viewModel: .init(item: item, orderController: orderController)
        )
        _ = menuItemDetailVC.view

        let initialValue = menuItemDetailVC.containerView.addOrRemoveFromOrderButton.title(for: .normal)

        menuItemDetailVC.containerView.addOrRemoveFromOrderButton.sendActions(for: .touchUpInside)

        XCTAssertNotEqual(
            menuItemDetailVC.containerView.addOrRemoveFromOrderButton.title(for: .normal),
            initialValue
        )
    }
}
