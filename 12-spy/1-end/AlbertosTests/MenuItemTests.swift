import Foundation
import Testing
@testable import Albertos

@MainActor
class `MenuItem Tests` {

  @Test func `can decode from JSON (from string)`() throws {
    let json = """
      {
        "name": "a name",
        "category": "a category",
        "spicy": true,
        "price": 1.0
      }
    """
    let data = try #require(json.data(using: .utf8))

    let item = try JSONDecoder()
      .decode(MenuItem.self, from: data)

    #expect(item.name == "a name")
    #expect(item.category == "a category")
    #expect(item.spicy == true)
    #expect(item.price == 1.0)
  }

  @Test func `can decode from JSON (from file)`() throws {
    let url = try #require(
      Bundle(for: type(of: self))
        .url(forResource: "menu_item", withExtension: "json")
    )
    let data = try Data(contentsOf: url)

    let item = try JSONDecoder()
      .decode(MenuItem.self, from: data)

    #expect(item.name == "a name")
    #expect(item.category == "a category")
    #expect(item.spicy == true)
    #expect(item.price == 1.0)
  }

  @Test func `can decode from JSON (from fixture)`() throws {
    let json = MenuItem.jsonFixture(
      name: "tiramisú",
      category: "desserts",
      spicy: false,
      price: 3.0
    )
    let data = try #require(json.data(using: .utf8))

    let item = try JSONDecoder()
      .decode(MenuItem.self, from: data)

    #expect(item.name == "tiramisú")
    #expect(item.category == "desserts")
    #expect(item.spicy == false)
    #expect(item.price == 3.0)
  }

  @Test func `decoding does not throw`() throws {
    let json = """
      {
        "name": "a name",
        "category": "a category",
        "spicy": true,
        "price": 1.0
      }
    """
    let data = try #require(json.data(using: .utf8))

    _ = try JSONDecoder().decode(MenuItem.self, from: data)
  }

  @Test(.disabled("This is just an example of how decoding might fail"))
  func `decoding works with nested object`() throws {
    let json = """
      {
        "name": "a name",
        "category": {
          "name": "pastas",
          "id": 123
        },
        "spicy": true,
        "price": 1.0
      }
    """
    let data = try #require(json.data(using: .utf8))

    let item = try JSONDecoder().decode(MenuItem.self, from: data)

    #expect(item.name == "a name")
    #expect(item.category == "a category")
    #expect(item.spicy == true)
    #expect(item.price == 1.0)
  }
}
