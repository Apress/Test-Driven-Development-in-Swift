import Testing
@testable import Albertos

struct `Menu Grouping` {

  @Test func `with many categories gives one section each`() {
    let menu = [
      MenuItem(category: "pastas", name: "a pasta"),
      MenuItem(category: "drinks", name: "a drink"),
      MenuItem(category: "pastas", name: "another pasta"),
      MenuItem(category: "desserts", name: "a dessert"),
    ]

    let sections = groupMenuByCategory(menu)

    #expect(sections.count == 3)
    #expect(sections[safe: 0]?.category == "Pastas")
    #expect(sections[safe: 1]?.category == "Drinks")
    #expect(sections[safe: 2]?.category == "Desserts")
  }

  @Test func `sorts by category in reverse alphabetical order`() {
    let menu = [
      MenuItem(category: "desserts", name: "a dessert"),
      MenuItem(category: "starters", name: "a starter"),
      MenuItem(category: "pastas", name: "a pasta"),
    ]

    let sections = groupMenuByCategory(menu)

    #expect(sections[safe: 0]?.category == "Starters")
    #expect(sections[safe: 1]?.category == "Pastas")
    #expect(sections[safe: 2]?.category == "Desserts")
  }

  @Test func `with one category gives one section`() throws {
    let menu = [
      MenuItem(category: "pastas", name: "name"),
      MenuItem(category: "pastas", name: "other name")
    ]

    let sections = groupMenuByCategory(menu)

    #expect(sections.count == 1)
    let section = try #require(sections.first)
    let items = section.items
    #expect(items.count == 2)
    #expect(items.first?.name == "name")
    #expect(items.last?.name == "other name")
  }

  @Test func `with empty menu gives empty sections`() {
    let menu = [MenuItem]()

    let sections = groupMenuByCategory(menu)

    #expect(sections.isEmpty)
  }
}
