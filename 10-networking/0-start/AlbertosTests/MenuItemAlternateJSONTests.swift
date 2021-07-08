//
// This is an example of how to decode models that don't match their JSON input.
// To avoid polluting the source code, we define the alternate MenuItem here.
//
// If you want to verify the failure, uncomment the import of the production module and comment the
// definition of MenuItem in this file
//@testable import Albertos
import XCTest

private struct MenuItem: Decodable {
    var category: String { categoryObject.name }
    let name: String
    let spicy: Bool
    let price: Double

    private let categoryObject: Category

    enum CodingKeys: String, CodingKey {
        case name, spicy, price
        case categoryObject = "category"
    }

    struct Category: Decodable {
        let name: String
    }
}

class MenuItemAlternateJSONTests: XCTestCase {

    func testWhenDecodedFromJSONDataHasAllTheInputProperties() throws {
        let json = """
{
    "name": "a name",
    "category": {
        "name": "a category",
        "id": 123
    },
    "spicy": false,
    "price": 1.0
}
"""
        let data = try XCTUnwrap(json.data(using: .utf8))

        let item: MenuItem
        do {
        item = try JSONDecoder().decode(MenuItem.self, from: data)
        } catch {
            XCTFail("\(error)")
            return
        }

        XCTAssertEqual(item.name, "a name")
        XCTAssertEqual(item.category, "a category")
        XCTAssertEqual(item.spicy, false)
        XCTAssertEqual(item.price, 1.0)
    }
}
