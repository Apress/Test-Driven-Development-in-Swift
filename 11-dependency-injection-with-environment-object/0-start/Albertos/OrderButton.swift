import SwiftUI

struct OrderButton: View {

  let viewModel: ViewModel = ViewModel()

  @State private(set) var showingDetail: Bool = false

  var body: some View {
    TextButton(
      action: { showingDetail.toggle() },
      text: viewModel.text
    )
    .sheet(isPresented: $showingDetail) {
      NavigationStack {
        OrderDetail()
      }
    }
  }
}
