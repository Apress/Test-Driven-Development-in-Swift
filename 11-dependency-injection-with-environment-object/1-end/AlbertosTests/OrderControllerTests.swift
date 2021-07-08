@testable import Albertos
import XCTest

class OrderControllerTests: XCTestCase {

    func testInitsWithEmptyOrder() {
        let controller = OrderController()

        XCTAssertTrue(controller.order.items.isEmpty)
    }

    func testWhenItemNotInOrderReturnsFalse() {
        let controller = OrderController()
        controller.addToOrder(item: .fixture(name: "a name"))

        XCTAssertFalse(controller.isItemInOrder(.fixture(name: "another name")))
    }

    func testWhenItemInOrderReturnsTrue() {
        let controller = OrderController()
        controller.addToOrder(item: .fixture(name: "a name"))

        XCTAssertTrue(controller.isItemInOrder(.fixture(name: "a name")))
    }

    func testAddingItemUpdatesOrder() {
        let controller = OrderController()

        let item = MenuItem.fixture()
        controller.addToOrder(item: item)

        XCTAssertEqual(controller.order.items.count, 1)
        XCTAssertEqual(controller.order.items.first, item)
    }

    func testRemovingItemUpdatesOrder() {
        let item = MenuItem.fixture(name: "a name")
        let otherItem = MenuItem.fixture(name: "another name")
        let controller = OrderController()
        controller.addToOrder(item: item)
        controller.addToOrder(item: otherItem)

        controller.removeFromOrder(item: item)

        XCTAssertEqual(controller.order.items.count, 1)
        XCTAssertEqual(controller.order.items.first, otherItem)
    }
}
