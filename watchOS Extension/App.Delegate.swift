import WatchKit
import UserNotifications

extension App {
    final class Delegate: NSObject, WKExtensionDelegate, UNUserNotificationCenterDelegate {
        func applicationDidFinishLaunching() {
            WKExtension.shared().registerForRemoteNotifications()
            UNUserNotificationCenter.current().delegate = self
        }
        
        func applicationDidBecomeActive() {
            cloud.pull.send()
        }
        
        func didReceiveRemoteNotification(_ userInfo: [AnyHashable : Any]) async -> WKBackgroundFetchResult {
            await cloud.notified ? .newData : .noData
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent: UNNotification) async -> UNNotificationPresentationOptions {
            await center.present(willPresent)
        }
    }
}
