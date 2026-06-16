struct MenuSection {
  let category: String
  let items: [MenuItem]
}

extension MenuSection: Equatable {}

extension MenuSection: Identifiable {
  var id: String { category }
}
