import WidgetKit
import SwiftUI

@main
struct TimerWidgetBundle: WidgetBundle {
    var body: some Widget {
        // This must match the name of the struct in your other widget file
        TimerActivityWidget()
    }
}
