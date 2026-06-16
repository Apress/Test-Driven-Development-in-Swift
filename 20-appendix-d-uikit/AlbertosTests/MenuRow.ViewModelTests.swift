import Testing
@testable import Albertos

struct `MenuRow ViewModel` {

  @Test func `when item is not spicy text is name only`() {
    let item = MenuItem.fixture(name: "name", spicy: false)

    let viewModel = MenuRowViewModel(item: item)

    #expect(viewModel.text == "name")
  }

  @Test func `when item is spicy text is name with emoji`() {
    let item = MenuItem.fixture(name: "name", spicy: true)

    let viewModel = MenuRowViewModel(item: item)

    #expect(viewModel.text == "name 🔥")
  }
}
