import Testing
@testable import Albertos

@MainActor
class OrderControllerTests {

  @Test func `inits with empty order`() {
    #expect(OrderController().order.items.isEmpty)
  }

  @Test func `when item not in order, returns false`() {
    let controller = OrderController()
    controller.addToOrder(item: .fixture(name: "a name"))

    #expect(
      controller.isItemInOrder(.fixture(name: "another name"))
      ==
      false
    )
  }

  @Test func `when item in order, returns true`() {
    let controller = OrderController()
    controller.addToOrder(item: .fixture(name: "a name"))

    #expect(
      controller.isItemInOrder(.fixture(name: "a name"))
      ==
      true
    )
  }

  @Test func `adding item updates order`() {
    let controller = OrderController()

    let item = MenuItem.fixture()
    controller.addToOrder(item: item)

    #expect(controller.order.items.count == 1)
    #expect(controller.order.items.first == item)
  }

  @Test func `removing item updates order`() {
    let item = MenuItem.fixture(name: "a name")
    let otherItem = MenuItem.fixture(name: "another name")
    let controller = OrderController()
    controller.addToOrder(item: item)
    controller.addToOrder(item: otherItem)
    #expect(controller.order.items.count == 2)

    controller.removeFromOrder(item: item)

    #expect(controller.order.items.count == 1)
    #expect(controller.order.items.first == otherItem)
  }
}
