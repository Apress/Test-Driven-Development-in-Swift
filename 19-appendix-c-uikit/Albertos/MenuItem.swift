struct MenuItem {

    let category: String
    let name: String
    let spicy: Bool
    let price: Double
}

extension MenuItem: Equatable {}

extension MenuItem: Codable {}
