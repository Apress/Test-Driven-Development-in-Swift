extension Order {

    var hippoPaymentsPayload: [String: Any] { ["items": items.map { $0.name }] }
}
