import SwiftUI
import Secrets

struct Tags: UIViewControllerRepresentable {
    let secret: Secret
    
    func makeUIViewController(context: Context) -> Controller {
        .init(rootView: Content(secret: secret))
    }
    
    func updateUIViewController(_: Controller, context: Context) {
        
    }
}
