@testable import Albertos

extension MenuSection {
    static func fixture(
        category: String = "a category",
        items: [MenuItem] = [.fixture()]
    ) -> MenuSection {
        MenuSection(category: category, items: items)
    }
}
