@testable import ProductsManager
import Testing

@Test func `sum of an empty array is zero`() {
    let category = "books"
    let products = [Product]()

    let sum = sumOf(products, withCategory: category)

    #expect(sum == 0)
}

@Test func `sum of a single item is the item price`() {
    let category = "books"
    let products = [
        Product(category: category, price: 3)
    ]

    let sum = sumOf(products, withCategory: category)

    #expect(sum == 3)
}

@Test func `sum includes only items from given category`() {
    let category = "books"
    let products = [
        Product(category: category, price: 1),
        Product(category: "movies", price: 2),
        Product(category: category, price: 3)
    ]

    let sum = sumOf(products, withCategory: category)

    #expect(sum == 4)
}
