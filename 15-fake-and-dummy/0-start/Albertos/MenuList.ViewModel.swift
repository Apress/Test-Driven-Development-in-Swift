import Combine

extension MenuList {

  class ViewModel: ObservableObject {

    @Published
    private(set) var sections: Result<[MenuSection], Error>

    private let menuFetching: MenuFetching
    private let menuGrouping: ([MenuItem]) -> [MenuSection]

    init(
      menuFetching: MenuFetching,
      menuGrouping: @escaping ([MenuItem]) -> [MenuSection]
        = groupMenuByCategory
    ) {
      self.menuFetching = menuFetching
      self.menuGrouping = menuGrouping
      sections = .success(menuGrouping([]))
    }

    func fetchMenu() async {
      do {
        sections = .success(
          try await menuGrouping(menuFetching.fetchMenu())
        )
      } catch {
        sections = .failure(error)
      }
    }
  }
}
