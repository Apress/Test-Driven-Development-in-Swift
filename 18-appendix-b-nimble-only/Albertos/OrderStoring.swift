protocol OrderStoring {

  func getOrder() -> Order

  func updateOrder(_ newOrder: Order)
}
