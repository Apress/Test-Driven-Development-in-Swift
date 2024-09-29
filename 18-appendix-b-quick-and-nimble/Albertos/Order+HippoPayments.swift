extension Order {
    var hippoPaymentsPayload: [String: Any] { ["items": items.map(\.name)] }
}
