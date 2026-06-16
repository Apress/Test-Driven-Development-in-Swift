import Combine
import Testing
@testable import Albertos

@MainActor class `MenuList ViewModel` {

  var cancellables = Set<AnyCancellable>()

  @Test
  func `when fetching starts publishes empty array`() throws {
    let viewModel = MenuList.ViewModel(
      menuFetching: MenuFetchingStub(
        returning: .success([.fixture()])
      )
    )

    let sections = try viewModel.sections.get()
    #expect(sections.isEmpty)
  }

  @Test
  func `when fetching succeeds publishes sections`() async {
    var receivedMenu: [MenuItem]? = nil
    let expectedSections = [MenuSection.fixture()]
    let spyClosure: ([MenuItem]) -> [MenuSection] = { menu in
      receivedMenu = menu
      return expectedSections
    }

    let inputMenu = [MenuItem.fixture()]
    let viewModel = MenuList.ViewModel(
      menuFetching: MenuFetchingStub(
        returning: .success(inputMenu)
      ),
      menuGrouping: spyClosure
    )

    var receivedValues: [Result<[MenuSection], Error>] = []
    viewModel
      .$sections
      .dropFirst()
      .sink { receivedValues.append($0) }
      .store(in: &cancellables)

    await viewModel.fetchMenu()

    // Grouping closure is called with the received menu
    #expect(receivedMenu == inputMenu)
    // Only one event was received
    #expect(receivedValues.count == 1)
    // Published value is the result of the grouping closure
    guard case .success(let s) = receivedValues[safe: 0] else {
      Issue.record("Expected to receive a successful value.")
      return
    }

    #expect(s == expectedSections)
  }

  @Test
  func `when fetching fails publishes an error`() async {
    let inputError = TestError(id: 123)
    let viewModel = MenuList.ViewModel(
      menuFetching: MenuFetchingStub(
        returning: .failure(inputError)
      )
    )

    var receivedValues: [Result<[MenuSection], Error>] = []
    viewModel
      .$sections
      .dropFirst()
      .sink { receivedValues.append($0) }
      .store(in: &cancellables)

    await viewModel.fetchMenu()

    #expect(receivedValues.count == 1)

    guard case .failure(let e) = receivedValues[safe: 0] else {
      Issue.record("Expected to receive an error.")
      return
    }

    #expect((e as? TestError) == inputError)
  }
}
