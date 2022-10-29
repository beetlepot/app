import WatchKit
import UserNotifications

extension App {
    final class Delegate: NSObject, WKApplicationDelegate, UNUserNotificationCenterDelegate {
        func applicationDidFinishLaunching() {
            WKApplication.shared().registerForRemoteNotifications()
            UNUserNotificationCenter.current().delegate = self
        }
        
        func didReceiveRemoteNotification(_: [AnyHashable : Any]) async -> WKBackgroundFetchResult {
            await cloud.backgroundFetch ? .newData : .noData
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent: UNNotification) async -> UNNotificationPresentationOptions {
            await center.present(willPresent)
        }
    }
}
