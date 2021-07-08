struct MenuItem {

    let category: String
    let name: String
}

extension MenuItem: Identifiable {

    var id: String { name }
}
