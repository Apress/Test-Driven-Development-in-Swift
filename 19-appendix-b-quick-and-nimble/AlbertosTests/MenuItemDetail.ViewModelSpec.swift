import Nimble
import Quick
@testable import Albertos

class OrderControllerSpec: AsyncSpec {

  override class func spec() {

    describe("OrderController") {

      describe("checking if an item is in the order") {

        context("when the order is empty") {

          it("says no") {
            let orderController = OrderController(
              orderStoring: OrderStoringFake()
            )
            expect(orderController.isItemInOrder(.fixture()))
              .to(beFalse())
          }
        }

        context("when the order has items") {

          context("when the item is in the order") {

            it("says yes") {
              let orderController = OrderController(
                orderStoring: OrderStoringFake()
              )
              let item = MenuItem.fixture()
              orderController.addToOrder(item: item)
              expect(orderController.isItemInOrder(item))
                .to(beTrue())
            }
          }

          context("when the item is not in the order") {

            it("says no") {
              let orderController = OrderController(
                orderStoring: OrderStoringFake()
              )
              let item = MenuItem.fixture()
              expect(orderController.isItemInOrder(item))
                .to(beFalse())
            }
          }
        }
      }
    }

    describe("OrderController") {

      let orderController = OrderController(
        orderStoring: OrderStoringFake()
      )

      describe("checking if an item is in the order") {

        context("when the order is empty") {

          it("says no") {
            expect(orderController.isItemInOrder(.fixture()))
              .to(beFalse())
          }
        }

        context("when the order has items") {

          let item = MenuItem.fixture(name: "a")
          orderController.addToOrder(item: item)

          context("when the item is in the order") {

            it("says yes") {
              expect(orderController.isItemInOrder(item))
                .to(beTrue())
            }
          }

          context("when the item is not in the order") {

            it("says no") {
              let otherItem = MenuItem.fixture(name: "b")
              expect(orderController.isItemInOrder(otherItem))
                .to(beFalse())
            }
          }
        }
      }
    }
  }
}
