import SwiftUI

struct MenuRow: View {

    let viewModel: ViewModel

    var body: some View {
        Text(viewModel.text)
    }
}
