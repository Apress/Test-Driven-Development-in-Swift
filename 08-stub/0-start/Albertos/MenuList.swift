import SwiftUI

struct MenuList: View {

  @ObservedObject var viewModel: ViewModel

  var body: some View {
    List {
      ForEach(viewModel.sections) { section in
        Section(header: Text(section.category)) {
          ForEach(section.items) { item in
            MenuRow(viewModel: .init(item: item))
          }
        }
      }
    }
    .task {
      await viewModel.fetchMenu()
    }
  }
}

#Preview {
  MenuList(
    viewModel: .init(menuFetching: MenuFetchingPlaceholder())
  )
}
