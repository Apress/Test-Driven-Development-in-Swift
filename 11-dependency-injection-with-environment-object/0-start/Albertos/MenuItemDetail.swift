import SwiftUI

struct MenuItemDetail: View {

    let viewModel: ViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.name)
                .fontWeight(.bold)

            if let spicy = viewModel.spicy {
                Text(spicy)
                    .font(Font.body.italic())
            }

            Text(viewModel.price)

            Spacer()
        }
        .padding(8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
