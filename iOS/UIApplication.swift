import StoreKit
import SwiftUI

extension UIApplication {
    func settings() {
        open(URL(string: Self.openSettingsURLString)!)
    }
    
    func hide() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func review() {
        scene
            .map(SKStoreReviewController.requestReview(in:))
    }
    
    private var scene: UIWindowScene? {
        connectedScenes
            .filter {
                $0.activationState == .foregroundActive
            }
            .compactMap {
                $0 as? UIWindowScene
            }
            .first
    }
}
