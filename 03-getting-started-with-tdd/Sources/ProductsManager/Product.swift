struct Product {
    let category: String
    let price: Double
}

func sumOf(
    _ products: [Product],
    withCategory category: String
) -> Double {
    return products
        .filter { $0.category == category }
        .reduce(0.0) { $0 + $1.price }
}
