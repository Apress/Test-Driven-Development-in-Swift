import SwiftUI

struct OrderDetail: View {

    let viewModel: ViewModel

    var body: some View {
        Text(viewModel.text)
    }
}

