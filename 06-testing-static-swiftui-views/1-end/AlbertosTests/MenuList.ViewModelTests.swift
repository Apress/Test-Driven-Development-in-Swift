import Testing
@testable import Albertos

@MainActor struct `MenuList ViewModel` {

  @Test func `uses the given grouping function`() throws {
    var receivedMenu: [MenuItem]? = nil
    let expectedSections = [MenuSection.fixture()]
    let spyClosure: ([MenuItem]) -> [MenuSection] = { menu in
      receivedMenu = menu
      return expectedSections
    }

    let viewModel = MenuList.ViewModel(
      menu: Albertos.menu, // See DummyMenu.swift
      menuGrouping: spyClosure
    )

    // Assert the given closure is called with the given menu
    let menu = try #require(receivedMenu)
    #expect(menu == Albertos.menu)
    // Assert the output of the given closure is used
    #expect(viewModel.sections == expectedSections)
  }
}
