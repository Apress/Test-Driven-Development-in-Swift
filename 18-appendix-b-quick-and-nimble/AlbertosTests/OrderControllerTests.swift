@testable import Albertos
import Nimble
import XCTest

class OrderControllerTests: XCTestCase {

    func testInitsWithEmptyOrder() {
        let controller = OrderController(orderStoring: OrderStoringFake())

        expect(controller.order.items).to(beEmpty())
    }

    func testWhenItemNotInOrderReturnsFalse() {
        let controller = OrderController(orderStoring: OrderStoringFake())
        controller.addToOrder(item: .fixture(name: "a name"))

        expect(controller.isItemInOrder(.fixture(name: "another name"))) == false
    }

    func testWhenItemInOrderReturnsTrue() {
        let controller = OrderController(orderStoring: OrderStoringFake())
        controller.addToOrder(item: .fixture(name: "a name"))

        expect(controller.isItemInOrder(.fixture(name: "a name"))) == true
        // Equivalent to:
        expect(controller.isItemInOrder(.fixture(name: "a name"))).to(beTruthy())
        // Equivalent to:
        expect(controller.isItemInOrder(.fixture(name: "a name"))).to(beTrue())
    }

    func testAddingItemUpdatesOrder() {
        let controller = OrderController(orderStoring: OrderStoringFake())

        let item = MenuItem.fixture()
        controller.addToOrder(item: item)

        expect(controller.order.items).to(haveCount(1))
        expect(controller.order.items.first) == item
    }

    func testRemovingItemUpdatesOrder() {
        let item = MenuItem.fixture(name: "a name")
        let otherItem = MenuItem.fixture(name: "another name")
        let controller = OrderController(orderStoring: OrderStoringFake())
        controller.addToOrder(item: item)
        controller.addToOrder(item: otherItem)

        controller.removeFromOrder(item: item)

        expect(controller.order.items).to(haveCount(1))
        expect(controller.order.items.first) == otherItem
    }
}
