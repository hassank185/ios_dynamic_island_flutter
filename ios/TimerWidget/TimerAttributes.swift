// In TimerAttributes.swift
import ActivityKit

struct TimerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var remainingTime: Int
    }

    var totalDuration: Int
}
