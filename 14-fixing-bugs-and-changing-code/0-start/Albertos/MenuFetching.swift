protocol MenuFetching {
  func fetchMenu() async throws -> [MenuItem]
}
