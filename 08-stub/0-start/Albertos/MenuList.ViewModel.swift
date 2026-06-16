import Combine

extension MenuList {

  class ViewModel: ObservableObject {

    @Published private(set) var sections: [MenuSection]

    private let menuFetching: MenuFetching
    private let menuGrouping: ([MenuItem]) -> [MenuSection]

    init(
      menuFetching: MenuFetching,
      menuGrouping: @escaping ([MenuItem]) -> [MenuSection]
        = groupMenuByCategory
    ) {
      self.menuFetching = menuFetching
      self.menuGrouping = menuGrouping
      sections = menuGrouping([])
    }

    func fetchMenu() async {
      sections = (try? await menuGrouping(
        menuFetching.fetchMenu()
      )) ?? []
    }
  }
}
