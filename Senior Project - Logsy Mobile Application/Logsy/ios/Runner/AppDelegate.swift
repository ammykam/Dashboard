import UIKit
import Flutter
import GoogleMaps
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyDnIStN5iWyxIUMV3QL6KkBQI4gNQ_0Q3w")
//    if #available(iOS 13.0, *) {
//     } else {
//         FirebaseApp.configure()
//     }
    GeneratedPluginRegistrant.register(with: self)
    
   
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
