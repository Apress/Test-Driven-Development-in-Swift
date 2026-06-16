import Testing
@testable import Albertos

struct `Order Payload` {

  @Test
  func `when order has no items payload is empty`() throws {
    let order = Order(items: [])

    let payload = order.hippoPaymentsPayload

    #expect(payload.count == 1)
    let items = try #require(payload["items"])
    #expect(items.isEmpty)
  }

  @Test
  func `when order has items payload contains them`() throws {
    let order = Order(
      items: [
        .fixture(name: "item"),
        .fixture(name: "other item")
      ]
    )

    let payload = order.hippoPaymentsPayload

    #expect(payload.count == 1)
    let items = try #require(payload["items"])
    #expect(items.contains("item"))
    #expect(items.contains("other item"))
  }
}
