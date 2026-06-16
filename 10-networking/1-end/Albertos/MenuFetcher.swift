import Foundation

class MenuFetcher: MenuFetching {

  let networkFetching: NetworkFetching

  init(networkFetching: NetworkFetching = URLSession.shared) {
    self.networkFetching = networkFetching
  }

  func fetchMenu() async throws -> [MenuItem] {
    let url = URL(
      string: "https://raw.githubusercontent.com/mokagio/" +
        "tddinswift_fake_api/trunk/menu_response.json"
    )!

    let request = URLRequest(url: url)
    let data = try await networkFetching.load(request)

    return try JSONDecoder().decode([MenuItem].self, from: data)
  }
}
