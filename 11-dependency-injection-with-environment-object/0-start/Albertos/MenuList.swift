import SwiftUI

struct MenuList: View {

  @ObservedObject var viewModel: ViewModel

  var body: some View {
    Group {
      switch viewModel.sections {
      case .success(let sections):
        List {
          ForEach(sections) { section in
            Section(header: Text(section.category)) {
              ForEach(section.items) { item in
                NavigationLink(
                  destination: MenuItemDetail(
                    viewModel: .init(item: item)
                  ),
                  label: {
                    MenuRow(viewModel: .init(item: item))
                  }
                )
              }
            }
          }
        }
      case .failure(let error):
        VStack {
          Text("An error occurred:")
          Text(error.localizedDescription).italic()
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
