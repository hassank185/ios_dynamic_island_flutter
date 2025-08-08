import WidgetKit
import SwiftUI
import ActivityKit

// MARK: – Shared Progress Bar
struct CustomProgressBar: View {
    var value: Double  // 0…1
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(width: geo.size.width, height: 6)
                    .foregroundColor(Color.white.opacity(0.3))
                Capsule()
                    .frame(width: geo.size.width * value, height: 6)
                    .foregroundColor(.white)
                Circle()
                    .fill(Color.cyan)
                    .frame(width: 20, height: 20)
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .offset(x: max(0, (geo.size.width - 20) * value))
            }
        }
        .frame(height: 20)
    }
}

// MARK: – Lock‑Screen Layout
struct LockScreenTimerView: View {
    let context: ActivityViewContext<TimerAttributes>

    private var total: Double {
        Double(context.attributes.totalDuration)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // header
            HStack {
                Text("DR. NUR AI")
                    .font(.footnote).bold().foregroundColor(.white)
                Spacer()
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.white.opacity(0.8))
            }

            Text("Do you want to continue")
                .font(.subheadline)
                .foregroundColor(.white)

            // one‑second ticks
            TimelineView(.periodic(from: .now, by: 1)) { _ in
                let remaining = Double(context.state.remainingTime)
                // fill from 0 → 1 as remaining goes from total → 0
                let progress = min(max((total - remaining) / total, 0), 1)

                CustomProgressBar(value: progress)
                    .frame(maxWidth: .infinity)

                HStack {
                    Text("00:00")
                    Spacer()
                    Text(Date(timeIntervalSinceNow: remaining), style: .timer)
                        .monospacedDigit()
                    Spacer()
                    Text(String(format: "%02d:00", Int(total) / 60))
                }
                .font(.footnote)
                .foregroundColor(.white.opacity(0.7))
            }

            HStack(spacing: 10) {
                Text("Cancel")
                    .font(.footnote).bold().foregroundColor(.white)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(14)

                Text("Continue")
                    .font(.footnote).bold().foregroundColor(.white)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(14)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(Color.black)
    }
}

// MARK: – Dynamic Island Layout
struct IslandTimerView: View {
    let context: ActivityViewContext<TimerAttributes>

    private var total: Double {
        Double(context.attributes.totalDuration)
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image("AppIcon")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("DR. NUR AI")
                    .font(.caption).bold().foregroundColor(.white)
                Spacer()
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white.opacity(0.8))
            }

            Text("Do you want to continue")
                .font(.body)
                .foregroundColor(.white)

            TimelineView(.periodic(from: .now, by: 1)) { _ in
                let remaining = Double(context.state.remainingTime)
                let progress = min(max((total - remaining) / total, 0), 1)

                CustomProgressBar(value: progress)
                    .frame(maxWidth: .infinity)

                HStack {
                    Text("00:00")
                    Spacer()
                    Text(Date(timeIntervalSinceNow: remaining), style: .timer)
                        .monospacedDigit()
                    Spacer()
                    Text(String(format: "%02d:00", Int(total) / 60))
                }
                .font(.caption2)
                .foregroundColor(.white.opacity(0.7))
            }

            HStack(spacing: 16) {
                Text("Cancel")
                    .font(.subheadline).bold().foregroundColor(.white)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(20)

                Text("Continue")
                    .font(.subheadline).bold().foregroundColor(.gray.opacity(0.8))
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(20)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(Color.black)
        .cornerRadius(20)
        .frame(minHeight: 140)
    }
}

// MARK: – Widget Configuration
struct TimerActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerAttributes.self) { context in
            LockScreenTimerView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.bottom) {
                    IslandTimerView(context: context)
                }
            } compactLeading: {
                Image(systemName: "timer").foregroundColor(.cyan)
            } compactTrailing: {
                Text(Date(
                    timeIntervalSinceNow:
                        TimeInterval(context.state.remainingTime)
                ), style: .timer)
                .foregroundColor(.cyan)
            } minimal: {
                Image(systemName: "timer").foregroundColor(.cyan)
            }
        }
    }
}
