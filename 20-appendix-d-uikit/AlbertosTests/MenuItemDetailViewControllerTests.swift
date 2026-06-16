import Testing
import UIKit // Required to access view property
@testable import Albertos

// Tests that interact with the UIKit view layer need to run on
// the main actor because various UIKit view updates can only
// run on the main thread.
@MainActor
class `MenuItemDetailViewModel Tests`{

  @Test func `configures view with ViewModel`() {
    let viewModel = MenuItemDetailViewModel(
      item: MenuItem.fixture(),
      orderController: OrderController(
        orderStoring: OrderStoringFake()
      )
    )
    let viewController = MenuItemDetailViewController(
      viewModel: viewModel
    )
    _ = viewController.view

    #expect(
      viewController.containerView.nameLabel.text
      ==
      viewModel.name
    )
    #expect(
      viewController.containerView.priceLabel.text
      ==
      viewModel.price
    )
    #expect(
      viewController.containerView.addOrRemoveFromOrderButton.title(for: .normal)
      ==
      viewModel.updateOrderButtonText
    )
    #expect(
      viewController.containerView.spicyLabel.text
      ==
      viewModel.spicy
    )
  }

  @Test func `updates order when button is actioned`() {
    let item = MenuItem.fixture()
    let orderController = OrderController(
      orderStoring: OrderStoringFake()
    )
    let viewController = MenuItemDetailViewController(
      viewModel: .init(
        item: item,
        orderController: orderController
      )
    )
    _ = viewController.view

    viewController.containerView.addOrRemoveFromOrderButton.sendActions(for: .touchUpInside)

    #expect(orderController.order.items.contains(item))

    viewController.containerView.addOrRemoveFromOrderButton.sendActions(for: .touchUpInside)

    #expect(orderController.order.items.contains(item) == false)
  }

  @Test func `updates view when button is actioned`() {
    let item = MenuItem.fixture()
    let orderController = OrderController(
      orderStoring: OrderStoringFake()
    )
    let viewController = MenuItemDetailViewController(
      viewModel: .init(
        item: item,
        orderController: orderController
      )
    )
    _ = viewController.view

    let initialValue = viewController
      .containerView
      .addOrRemoveFromOrderButton
      .title(for: .normal)

    viewController
      .containerView
      .addOrRemoveFromOrderButton
      .sendActions(for: .touchUpInside)

    #expect(
      viewController
        .containerView
        .addOrRemoveFromOrderButton
        .title(for: .normal)
      !=
      initialValue
    )
  }
}
