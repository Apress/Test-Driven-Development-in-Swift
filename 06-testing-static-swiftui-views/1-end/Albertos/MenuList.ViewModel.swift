extension MenuList {
    struct ViewModel {
        let sections: [MenuSection]

        init(
            menu: [MenuItem],
            menuGrouping: @escaping ([MenuItem]) -> [MenuSection] = groupMenuByCategory
        ) {
            sections = menuGrouping(menu)
        }
    }
}
