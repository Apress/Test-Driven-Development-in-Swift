@testable import Albertos
import Nimble
import XCTest

class MenuGroupingTests: XCTestCase {

    func testMenuWithManyCategoriesReturnsAsManySectionsInReverseAlphabeticalOrder() {
        let menu: [MenuItem] = [
            .fixture(category: "pastas"),
            .fixture(category: "drinks"),
            .fixture(category: "pastas"),
            .fixture(category: "desserts"),
        ]

        let sections = groupMenuByCategory(menu)

        // Nimble offers a dedicate assertion for Array count:
        //
        expect(sections).to(haveCount(3))
        //
        // Using this is better than:
        //
        expect(sections.count) == 3
        //
        // `haveCount()` produces a better failure message; it will fail with:
        //
        // > expected to have Array<MenuSection> with count 2, got 3
        //
        // The equality assertion fails with:
        //
        // > expected to equal <3>, got <2>
        //
        // The clearer failure means it will be easier for future developers to understand what
        // went wrong and where to look for to start fixing it.

        expect(sections[safe: 0]?.category) == "pastas"
        expect(sections[safe: 1]?.category) == "drinks"
        expect(sections[safe: 2]?.category) == "desserts"

        // An alternative way to write equality assertions with Nimble is:
        //
        expect(sections[safe: 0]?.category).to(equal("pastas"))
        //
        // This style results in homogeneous assertions, as not all the matchers come with a custom
        // operator like the equality one does.
        //
        // I prefer using `==` for its conciseness.
    }

    func testMenuWithOneCategoryReturnsOneSection() throws {
        let menu: [MenuItem] = [
            .fixture(category: "pastas", name: "name"),
            .fixture(category: "pastas", name: "other name")
        ]

        let sections = groupMenuByCategory(menu)

        expect(sections).to(haveCount(1))
        let section = try XCTUnwrap(sections.first)
        expect(section.items).to(haveCount(2))
        expect(section.items.first?.name) == "name"
        expect(section.items.last?.name) == "other name"
    }

    func testEmptyMenuReturnsEmptySections() {
        let menu = [MenuItem]()

        let sections = groupMenuByCategory(menu)

        expect(sections).to(beEmpty())
        // Similarly to `haveCount` vs. `equal`, using `beEmpty` is better than `haveCount` because
        // it fails with a clearer message:
        //
        // > expected to be empty, got <[<array content>]>
        //
        // This matcher makes the test intent clearer.
    }
}
