@testable import Albertos
import XCTest

class OrderButtonViewModelTests: XCTestCase {

    func testWhenOrderIsEmptyDoesNotShowTotal() {
        let (sut, _) = makeSUT()

        XCTAssertEqual(sut.text, "Your Order")
    }

    func testWhenOrderIsNotEmptyShowsTotal() {
        let (sut, order) = makeSUT()
        
        order.addToOrder(item: .fixture(price: 1.0))
        XCTAssertEqual(sut.text, "Your Order $1.00")
        
        order.addToOrder(item: .fixture(price: 2.3))
        XCTAssertEqual(sut.text, "Your Order $3.30")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (OrderButton.ViewModel, OrderController) {
        let orderController = OrderController()
        let sut = OrderButton.ViewModel(orderController: orderController)
     
        
        return (sut, orderController)
    }
}

