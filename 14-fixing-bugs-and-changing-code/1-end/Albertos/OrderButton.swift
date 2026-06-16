import SwiftUI

struct OrderButton: View {

  let viewModel: ViewModel

  @State private(set) var showingDetail: Bool = false

  @EnvironmentObject
  private var orderController: OrderController

  var body: some View {
    TextButton(
      action: { showingDetail.toggle() },
      text: viewModel.text
    )
    .sheet(isPresented: $showingDetail) {
      NavigationStack {
        OrderDetail(
          viewModel: .init(
            orderController: orderController,
            onAlertDismiss: { showingDetail.toggle() }
          ),
        )
      }
    }
  }
}
