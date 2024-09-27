import SwiftUI

struct MenuList: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        switch viewModel.sections {
        case let .success(sections):
            List {
                ForEach(sections) { section in
                    Section(header: Text(section.category)) {
                        ForEach(section.items) { item in
                            NavigationLink(destination: MenuItemDetail(viewModel: .init(item: item))) {
                                MenuRow(viewModel: .init(item: item))
                            }
                        }
                    }
                }
            }
        case let .failure(error):
            Text("An error occurred:")
            Text(error.localizedDescription).italic()
        }
    }
}
