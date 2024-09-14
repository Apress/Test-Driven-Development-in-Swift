struct Order {

    let items: [MenuItem]

    var total: Double { items.reduce(0) { $0 + $1.price } }
}

extension Order: Equatable {}
