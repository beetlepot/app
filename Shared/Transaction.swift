import StoreKit
import UserNotifications
import Secrets

extension Transaction {
    func process() async {
        let purchase = Purchase(rawValue: productID)!
        if revocationDate == nil {
            await cloud.add(purchase: purchase)
            await UNUserNotificationCenter.send(message: "Purchase successful!")
        } else {
            await cloud.remove(purchase: purchase)
        }
        await finish()
    }
}
