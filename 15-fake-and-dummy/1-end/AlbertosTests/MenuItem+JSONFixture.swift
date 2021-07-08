@testable import Albertos

extension MenuItem {

    static func jsonFixture(
        name: String = "a name",
        category: String = "a category",
        spicy: Bool = false,
        price: Double = 1.0
    ) -> String {
        return """
{
    "name": "\(name)",
    "category": "\(category)",
    "spicy": \(spicy),
    "price": \(price)
}
"""
    }
}
