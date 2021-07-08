struct MenuItem {

    let category: String
    let name: String
    let spicy: Bool
    let price: Double
}

extension MenuItem: Identifiable {

    var id: String { name }
}

extension MenuItem: Equatable {}
