protocol OrderStoring {

    func getOrder() -> Order

    func updateOrder(_ order: Order)
}
