@testable import Albertos

extension MenuItem {

  static func fixture(
    category: String = "category",
    name: String = "name",
    spicy: Bool = false,
    price: Double = 1.0
  ) -> MenuItem {
    MenuItem(category: category, name: name, spicy: spicy, price: price)
  }
}
