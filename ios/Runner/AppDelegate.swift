import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Temporarily disabled for iOS 26 device testing: several native plugins
    // crash during registration before Flutter renders the first screen.
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
