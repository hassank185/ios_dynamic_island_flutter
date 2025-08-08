import UIKit
import Flutter
import ActivityKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    var liveActivity: Activity<TimerAttributes>? = nil

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let timerChannel = FlutterMethodChannel(
            name: "com.test.liveactivity/timer",
            binaryMessenger: controller.binaryMessenger
        )
        timerChannel.setMethodCallHandler { [weak self]
            (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let self = self else { return }
            switch call.method {
            case "startLiveActivity":
                if let args = call.arguments as? [String: Any],
                   let duration = args["duration"] as? Int {
                    self.startActivity(duration: duration)
                    result(nil)
                } else {
                    result(FlutterError(
                        code: "INVALID_ARGUMENTS",
                        message: "Invalid arguments",
                        details: nil
                    ))
                }
            case "updateLiveActivity":
                if let args = call.arguments as? [String: Any],
                   let remainingTime = args["remainingTime"] as? Int {
                    self.updateActivity(remainingTime: remainingTime)
                    result(nil)
                } else {
                    result(FlutterError(
                        code: "INVALID_ARGUMENTS",
                        message: "Invalid arguments",
                        details: nil
                    ))
                }
            case "stopLiveActivity":
                self.stopActivity()
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func startActivity(duration: Int) {
        guard liveActivity == nil else { return }
        let attributes = TimerAttributes(totalDuration: duration)
        let state = TimerAttributes.ContentState(remainingTime: duration)
        Task {
            do {
                liveActivity = try Activity<TimerAttributes>.request(
                    attributes: attributes,
                    contentState: state,
                    pushType: nil
                )
                print("Requested a timer activity.")
            } catch {
                print("Error requesting timer activity: \(error.localizedDescription)")
            }
        }
    }

    func updateActivity(remainingTime: Int) {
        let state = TimerAttributes.ContentState(remainingTime: remainingTime)
        Task {
            await liveActivity?.update(using: state)
        }
    }

    func stopActivity() {
        let state = TimerAttributes.ContentState(remainingTime: 0)
        Task {
            await liveActivity?.end(using: state, dismissalPolicy: .immediate)
            self.liveActivity = nil
        }
    }
}
