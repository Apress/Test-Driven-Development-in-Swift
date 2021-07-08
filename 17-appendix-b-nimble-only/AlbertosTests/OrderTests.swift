@testable import Albertos
import Nimble
import XCTest

class OrderTests: XCTestCase {

    func testTotalSumsPricesOfEachItem() {
        let order = Order(
            items: [.fixture(price: 1.0), .fixture(price: 2.0), .fixture(price: 3.5)]
        )

        expect(order.total) == 6.5
    }

    func testHippoPaymentsPayloadHasOrderItemsNames() throws {
        let order = Order(
            items: [.fixture(name: "a name"), .fixture(name: "other name")]
        )

        let payload = order.hippoPaymentsPayload

        let payloadItems = try XCTUnwrap(payload["items"] as? [String])
        expect(payloadItems).to(haveCount(2))
        expect(payloadItems.first) == "a name"
        expect(payloadItems.last) == "other name"
    }
}
