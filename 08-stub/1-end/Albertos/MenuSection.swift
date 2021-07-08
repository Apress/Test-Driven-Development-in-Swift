struct MenuSection {

    let category: String
    let items: [MenuItem]
}

extension MenuSection: Identifiable {

    var id: String { category }
}

extension MenuSection: Equatable {}
