import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "G_MAPS_API_KEY") as? String,
                !apiKey.isEmpty {
                GMSServices.provideAPIKey(apiKey)
            } else {
                fatalError("G_MAPS_API_KEY is missing. Check Secrets.xcconfig & Info.plist")
            }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
