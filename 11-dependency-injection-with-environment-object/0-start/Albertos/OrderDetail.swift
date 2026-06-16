// This is just a placeholder screen for the moment.
import SwiftUI

struct OrderDetail: View {

  let viewModel = ViewModel()

  var body: some View {
    VStack(alignment: .center, spacing: 8) {
      Text(viewModel.headerText)
        .font(Font.title.bold())
      List {
        ForEach(viewModel.menuItems) { item in
          Text(item.name)
        }
      }.listStyle(.inset)
      Spacer()
      Text(viewModel.totalPriceText)
    }
    .padding(16)
  }
}

#Preview {
  OrderDetail()
}
