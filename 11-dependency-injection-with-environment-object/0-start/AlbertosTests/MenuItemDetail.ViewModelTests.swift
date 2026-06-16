import Testing
@testable import Albertos

struct `MenuItemDetail ViewModel` {

  @Test func `reads name from item`() {
    let item = MenuItem.fixture(name: "name")
    let viewModel = MenuItemDetail.ViewModel(item: item)

    #expect(viewModel.name == "name")
  }

  @Test func `when item is spicy, has spicy label`() {
    let item = MenuItem.fixture(spicy: true)
    let viewModel = MenuItemDetail.ViewModel(item: item)

    #expect(viewModel.spicy == "Spicy")
  }

  @Test func `when item is not spicy, has no spicy label`() {
    let item = MenuItem.fixture(spicy: false)
    let viewModel = MenuItemDetail.ViewModel(item: item)

    #expect(viewModel.spicy == .none)
  }

  @Test(
    arguments: zip(
      [1.234, 2.345, 3.456],
      ["$1.23", "$2.35", "$3.46"]
    )
  )
  func `shows price with $ sign and rounds to nearest`(
    price: Double,
    expectedValue: String
  ) {
    let item = MenuItem.fixture(price: price)
    let viewModel = MenuItemDetail.ViewModel(item: item)

    #expect(viewModel.price == expectedValue)
  }
}
