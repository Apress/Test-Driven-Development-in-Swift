extension MenuRow {

    struct ViewModel {

        let text: String

        init(item: MenuItem) {
            text = item.spicy ? "\(item.name) 🔥" : item.name
        }
    }
}
