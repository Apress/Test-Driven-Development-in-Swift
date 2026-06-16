import SwiftUI

struct MenuRow: View {

  let viewModel: ViewModel

  var body: some View {
    Text(viewModel.text)
  }
}

#Preview {
  MenuRow(
    viewModel: .init(
      item: MenuItem(
        category: "any",
        name: "spicy",
        spicy: true,
        price: 1.5
      )
    )
  )
  MenuRow(
    viewModel: .init(
      item: MenuItem(
        category: "any",
        name: "not spicy",
        spicy: false,
        price: 1.5
      )
    )
  )
}
