import XCTest

extension XCTestCase {

    /// Using a wait time of around 1 second seems to result in occasional
    /// test timeout failures when using `XCTNSPredicateExpectation`s.
    var timeoutForPredicateExpectations: Double { 2.0 }
}
