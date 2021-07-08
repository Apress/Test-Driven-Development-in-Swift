@testable import Albertos
import Nimble
import Quick

class MenuItemDetailViewModelSpec: QuickSpec {

    override func spec() {

        // Quick lets you organize your test using plain language:
        // "MenuItemDetail.ViewModel, order button, when the item is in the order, says remove from order".
        describe("MenuItemDetail.ViewModel") {

            describe("order button") {
                // It also allow for an efficient grouping of common setup code while still having isolated
                // tests.
                //
                // Important: do no put setup code outside of the `describe`, `context`, and
                // `it` closures. (Need to explain why)
                let item = MenuItem.fixture()
                let orderController = OrderController(orderStoring: OrderStoringFake())

                context("when the item is in the order") {
                    orderController.addToOrder(item: item)
                    let viewModel = MenuItemDetail.ViewModel(item: item, orderController: orderController)

                    it("says remove from order") {
                        let text = viewModel.addOrRemoveFromOrderButtonText
                        expect(text) == "Remove from order"
                    }

                    it("removes the item from the order") {
                        viewModel.addOrRemoveFromOrder()

                        expect(orderController.order.items).toNot(containElementSatisfying({ $0 == item }))
                    }
                }

                context("when the item is not in the order") {
                    let viewModel = MenuItemDetail.ViewModel(item: item, orderController: orderController)

                    it("says add to order") {
                        let text = viewModel.addOrRemoveFromOrderButtonText
                        expect(text) == "Add to order"
                    }

                    it("adds the item to the order") {
                        viewModel.addOrRemoveFromOrder()

                        expect(orderController.order.items).to(containElementSatisfying({ $0 == item }))
                    }
                }
            }

            describe("order button (compact setup)") {
                // Alternatively, you can replicate the setup code in each example, to avoid
                // spreading the code affecting each test and keep them compact.
                context("when the item is in the order") {

                    it("says remove from order") {
                        let item = MenuItem.fixture()
                        let orderController = OrderController(orderStoring: OrderStoringFake())
                        orderController.addToOrder(item: item)
                        let viewModel = MenuItemDetail.ViewModel(item: item, orderController: orderController)

                        let text = viewModel.addOrRemoveFromOrderButtonText

                        expect(text) == "Remove from order"
                    }

                    it("removes the item from the order") {
                        let item = MenuItem.fixture()
                        let orderController = OrderController(orderStoring: OrderStoringFake())
                        orderController.addToOrder(item: item)
                        let viewModel = MenuItemDetail.ViewModel(item: item, orderController: orderController)

                        viewModel.addOrRemoveFromOrder()

                        expect(orderController.order.items).toNot(containElementSatisfying({ $0 == item }))
                    }
                }

                context("when the item is not in the order") {

                    it("says add to order") {
                        let item = MenuItem.fixture()
                        let orderController = OrderController(orderStoring: OrderStoringFake())
                        let viewModel = MenuItemDetail.ViewModel(item: item, orderController: orderController)

                        let text = viewModel.addOrRemoveFromOrderButtonText

                        expect(text) == "Add to order"
                    }

                    it("adds the item to the order") {
                        let item = MenuItem.fixture()
                        let orderController = OrderController(orderStoring: OrderStoringFake())
                        let viewModel = MenuItemDetail.ViewModel(item: item, orderController: orderController)

                        viewModel.addOrRemoveFromOrder()

                        expect(orderController.order.items).to(containElementSatisfying({ $0 == item }))
                    }
                }
            }
        }
    }
}
