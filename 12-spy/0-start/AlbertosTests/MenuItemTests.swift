@testable import Albertos
import XCTest

class MenuItemTests: XCTestCase {

    // MARK: Inline example with Triangulation

    func testWhenDecodedFromJSONDataHasAllTheInputPropertiesExample1() throws {
        let json = #"{ "name": "a name", "category": "a category", "spicy": true, "price": 1.0 }"#
        let data = try XCTUnwrap(json.data(using: .utf8))

        let item = try JSONDecoder().decode(MenuItem.self, from: data)

        XCTAssertEqual(item.name, "a name")
        XCTAssertEqual(item.category, "a category")
        XCTAssertEqual(item.spicy, true)
        XCTAssertEqual(item.price, 1.0)
    }

    func testWhenDecodedFromJSONDataHasAllTheInputPropertiesExample2() throws {
        let json = #"{ "name": "another name", "category": "another category", "spicy": false, "price": 2.0 }"#
        let data = try XCTUnwrap(json.data(using: .utf8))

        let item = try JSONDecoder().decode(MenuItem.self, from: data)

        XCTAssertEqual(item.name, "another name")
        XCTAssertEqual(item.category, "another category")
        XCTAssertEqual(item.spicy, false)
        XCTAssertEqual(item.price, 2.0)
    }

    // MARK: Inline example with helper function

    func testWhenDecodedFromJSONDataHasAllTheInputProperties_HelperFunction() throws {
        let json = MenuItem.jsonFixture(name: "a name", category: "a category", spicy: false, price: 1.0)
        let data = try XCTUnwrap(json.data(using: .utf8))

        let item = try JSONDecoder().decode(MenuItem.self, from: data)

        XCTAssertEqual(item.name, "a name")
        XCTAssertEqual(item.category, "a category")
        XCTAssertEqual(item.spicy, false)
        XCTAssertEqual(item.price, 1.0)
    }

    // MARK: From JSON file example

    func testWhenDecodedFromJSONDataHasAllTheInputProperties_JSONFile() throws {
        let data = try dataFromJSONFileNamed("menu_item")

        let item = try JSONDecoder().decode(MenuItem.self, from: data)

        XCTAssertEqual(item.name, "a name")
        XCTAssertEqual(item.category, "a category")
        XCTAssertEqual(item.spicy, true)
        XCTAssertEqual(item.price, 1.0)
    }

    // MARK: Simpler check example
    // Use this option if your models match the shape of the input JSON.

    func testWhenDecodingFromJSONDataDoesNotThrow() throws {
        let json = #"{ "name": "a name", "category": "a category", "spicy": true, "price": 1.0 }"#
        let data = try XCTUnwrap(json.data(using: .utf8))

        XCTAssertNoThrow(try JSONDecoder().decode(MenuItem.self, from: data))
    }
}
