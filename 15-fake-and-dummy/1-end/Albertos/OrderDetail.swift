// This is just a placeholder screen for the moment.
import SwiftUI

struct OrderDetail: View {

  @ObservedObject private(set) var viewModel: ViewModel

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

      if let totalPriceText = viewModel.totalPriceText {
        Text(totalPriceText)
      }

      TextButton(
        action: viewModel.checkout,
        text: viewModel.checkoutButtonText
      )
    }
    .padding(16)
    .alert(
      viewModel.alertViewModel?.titleText ?? "",
      isPresented: $viewModel.shouldShowAlert,
      presenting: viewModel.alertViewModel,
      actions: { alertViewModel in
        Button(alertViewModel.dismissButtonText) {
          alertViewModel.dismissButtonAction()
        }
      },
      message: { alertViewModel in
        Text(alertViewModel.messageText)
      }
    )
  }
}

#Preview {
  OrderDetail(
    viewModel: .init(
      orderController: OrderController(),
      onAlertDismiss: {}
    )
  )
}
