// This is just a placeholder screen for the moment.
import SwiftUI

struct OrderDetail: View {

  let viewModel = ViewModel()

  var body: some View {
    VStack(alignment: .center, spacing: 8) {
      Text(viewModel.headerText)
        .font(Font.title.bold())
      List {
        Text("Items will go here")
        Text("Items will go here")
      }.listStyle(.inset)
      Spacer()
      Text("Total price will go here")
    }
    .padding(16)
  }
}

#Preview {
  OrderDetail()
}
