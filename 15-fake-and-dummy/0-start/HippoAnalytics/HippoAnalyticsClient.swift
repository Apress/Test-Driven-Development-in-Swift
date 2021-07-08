public class HippoAnalyticsClient {

    public init(apiKey: String) {}

    public func logEvent(named name: String, properties: [String: Any]? = .none) {
        if let properties = properties {
            print("🦛 HippoAnalytics: Logged event named '\(name)' with properties '\(properties)'")
        } else {
            print("🦛 HippoAnalytics: Logged event named '\(name)'")
        }
    }
}
