extension Order {

  var hippoPaymentsPayload: [String: [String]] {
    return ["items": items.map { $0.name }]
  }
}
