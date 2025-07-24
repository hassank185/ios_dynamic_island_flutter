import WidgetKit
import SwiftUI
import ActivityKit

struct TimerActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerAttributes.self) { context in
            // Lock screen/banner UI
            VStack {
                Text("Timer")
                    .font(.headline)
                HStack {
                    Text(Date(timeIntervalSinceNow: TimeInterval(context.state.remainingTime)), style: .timer)
                        .font(.largeTitle)
                }
            }
            .padding()
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    Text("Timer")
                        .font(.headline)
                }
                DynamicIslandExpandedRegion(.trailing) {
                     Text(Date(timeIntervalSinceNow: TimeInterval(context.state.remainingTime)), style: .timer)
                        .font(.headline)
                }
                DynamicIslandExpandedRegion(.center) {
                   Text("Remaining")
                     .font(.caption)
                }
                // *** THIS IS THE CHANGE ***
                // The bottom region is now empty, so the progress bar is removed.
                DynamicIslandExpandedRegion(.bottom) {
                    // Nothing here
                }
            } compactLeading: {
                Image(systemName: "timer")
                    .foregroundColor(.cyan)
            } compactTrailing: {
                // I also fixed a small issue here to make sure the correct time shows.
                Text(Date(timeIntervalSinceNow: TimeInterval(context.state.remainingTime)), style: .timer)
                    .foregroundColor(.cyan)
            } minimal: {
                Image(systemName: "timer")
                    .foregroundColor(.cyan)
            }
        }
    }
}
