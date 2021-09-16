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
    
    func sheet() {
        guard let presenter = scene.flatMap(\.windows.first?.rootViewController) else { return }
        let controller = UIHostingController(rootView: Circle())
        controller
            .sheetPresentationController
            .map {
                $0.detents = [.medium()]
                $0.prefersScrollingExpandsWhenScrolledToEdge = false
                $0.largestUndimmedDetentIdentifier = .medium
                
            }
        presenter.present(controller, animated: true)
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
