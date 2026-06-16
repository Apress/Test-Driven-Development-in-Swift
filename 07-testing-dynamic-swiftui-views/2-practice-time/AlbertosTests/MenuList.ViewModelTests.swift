import Combine
import Testing
@testable import Albertos

@MainActor class `MenuList ViewModel` {

  var cancellables = Set<AnyCancellable>()

  @Test func `when fetching starts publishes empty array`() {
    let viewModel = MenuList.ViewModel(
      menuFetching: MenuFetchingPlaceholder()
    )

    #expect(viewModel.sections.isEmpty)
  }

  @Test
  func `when fetching succeeds publishes sections`() async {
    var receivedMenu: [MenuItem]? = nil
    let expectedSections = [MenuSection.fixture()]
    let spyClosure: ([MenuItem]) -> [MenuSection] = { menu in
      receivedMenu = menu
      return expectedSections
    }

    let viewModel = MenuList.ViewModel(
      menuFetching: MenuFetchingPlaceholder(),
      menuGrouping: spyClosure
    )

    var receivedValues: [[MenuSection]] = []
    viewModel
      .$sections
      .dropFirst()
      .sink { receivedValues.append($0) }
      .store(in: &cancellables)

    await viewModel.fetchMenu()

    // Grouping closure is called with the received menu
    #expect(receivedMenu == menu)
    // Only one event was received
    #expect(receivedValues.count == 1)
    // Published value is the result of the grouping closure
    #expect(receivedValues[safe: 0] == expectedSections)
  }

  @Test
  func `first published empty array, then sections if menu fetch ok`() async {
    let viewModel = MenuList.ViewModel(
      menuFetching: MenuFetchingPlaceholder()
    )

    var receivedValues: [[MenuSection]] = []
    viewModel
      .$sections
      .sink { receivedValues.append($0) }
      .store(in: &cancellables)

    await viewModel.fetchMenu()

    #expect(receivedValues.count == 2)

    #expect(receivedValues[safe: 0] == [])
    #expect(receivedValues[safe: 1] != [])
  }

  @Test func `when fetching fails publishes an error`() {}
}
