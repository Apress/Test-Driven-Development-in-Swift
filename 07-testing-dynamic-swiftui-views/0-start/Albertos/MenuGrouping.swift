import Foundation

func groupMenuByCategory(_ menu: [MenuItem]) -> [MenuSection] {
  return Dictionary(grouping: menu, by: { $0.category })
    .map { key, value in
      MenuSection(category: key.capitalized, items: value)
    }
    .sorted { $0.category > $1.category }
}
