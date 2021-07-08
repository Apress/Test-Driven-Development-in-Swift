import SwiftUI

struct OrderButton: View {

    @ObservedObject private(set) var viewModel: ViewModel

    @State private(set) var showingDetail: Bool = false
    @EnvironmentObject var orderController: OrderController

    var body: some View {
        Button {
            self.showingDetail.toggle()
        } label: {
            Text(viewModel.text)
                .font(Font.callout.bold())
                .padding(12)
                .foregroundColor(.white)
                .background(Color.crimson)
                .cornerRadius(10.0)
        }
        .sheet(isPresented: $showingDetail) {
            OrderDetail(viewModel: .init(orderController: orderController))
        }
    }
}
