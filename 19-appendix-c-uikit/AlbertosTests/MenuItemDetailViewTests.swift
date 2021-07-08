@testable import Albertos
import XCTest

class MenuItemDetailViewTests: XCTestCase {

    func testWhenViewModelHasSpicyNilDoesNotAddSpicyLabel() {
        let viewModel = MenuItemDetailViewModel(
            item: .fixture(spicy: false),
            orderController: OrderController(orderStoring: OrderStoringFake())
        )
        // Because we can only set the spicy property of the ViewModel indirectly via its item,
        // let's make sure it matches our assumption before proceeding with the test.
        XCTAssertNil(viewModel.spicy)

        let view = MenuItemDetailView()

        view.configureContent(with: viewModel)

        XCTAssertFalse(view.arrangedSubviews.contains(view.spicyLabel))
    }

    func testWhenViewModelHasSpicyNonNilAddsSpicyLabel() {
        let viewModel = MenuItemDetailViewModel(
            item: .fixture(spicy: true),
            orderController: OrderController(orderStoring: OrderStoringFake())
        )
        XCTAssertNotNil(viewModel.spicy)

        let view = MenuItemDetailView()

        view.configureContent(with: viewModel)

        XCTAssertTrue(view.arrangedSubviews.contains(view.spicyLabel))
    }
}
