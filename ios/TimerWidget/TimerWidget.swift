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
                DynamicIslandExpandedRegion(.bottom) {
                    ProgressView(timerInterval: Date(timeIntervalSinceNow: 0)...Date(timeIntervalSinceNow: TimeInterval(context.attributes.totalDuration)),
                                 countsDown: true)
                        .progressViewStyle(.linear)
                }
            } compactLeading: {
                Image(systemName: "timer")
                    .foregroundColor(.cyan)
            } compactTrailing: {
                Text(Date(timeIntervalSinceNow: TimeInterval(context.state.remainingTime)), style: .timer)
                    .foregroundColor(.cyan)
            } minimal: {
                Image(systemName: "timer")
                    .foregroundColor(.cyan)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}
