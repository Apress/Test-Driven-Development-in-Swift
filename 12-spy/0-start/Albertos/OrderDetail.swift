import SwiftUI

struct OrderDetail: View {

    let viewModel: ViewModel

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(viewModel.headerText)

            // For the sake of keeping these examples small, we're making two compromises here:
            //
            // - There is logic in the view to inspect the menu list decide whether to show it or
            //   use the fallback text if it's empty.
            // - There is logic in the view to read the name from the `MenuItem`, instead of having
            //   a dedicated view and ViewModel for the row.
            //
            // A better approach would be to have an enum describing the two mutually exclusive
            // states, and switching on it to read either the text to show or the list of items.
            if viewModel.menuListItems.isEmpty {
                Text(viewModel.emptyMenuFallbackText).multilineTextAlignment(.center)
            } else {
                List(viewModel.menuListItems) { Text($0.name) }
            }

            if let total = viewModel.totalText {
                Text(total)
            }

            Spacer()
        }
        .padding(8)
    }
}
