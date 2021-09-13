import StoreKit

extension UIApplication {
    func settings() {
        open(URL(string: Self.openSettingsURLString)!)
    }
    
    func hide() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func review() {
        SKStoreReviewController.requestReview(in: connectedScenes.compactMap { $0 as? UIWindowScene }.first!)
    }
}
