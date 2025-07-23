import ActivityKit

struct TimerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // This is the dynamic data that your app will update.
        var remainingTime: Int
    }

    // This is the static data that doesn't change.
    var totalDuration: Int
}
