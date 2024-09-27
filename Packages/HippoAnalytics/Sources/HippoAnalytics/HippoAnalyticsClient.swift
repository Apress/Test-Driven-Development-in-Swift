public class HippoAnalyticsClient {
    public init(apiKey _: String) {}

    public func logEvent(named name: String, properties: [String: Any]? = .none) {
        if let properties {
            print("🦛 HippoAnalytics: Logged event named '\(name)' with properties '\(properties)'")
        } else {
            print("🦛 HippoAnalytics: Logged event named '\(name)'")
        }
    }
}
