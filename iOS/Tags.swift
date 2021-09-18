import SwiftUI
import Secrets

struct Tags: UIViewControllerRepresentable {
    @State var secret: Secret
    
    func makeUIViewController(context: Context) -> Controller {
        .init(rootView: .init(secret: $secret))
    }
    
    func updateUIViewController(_: Controller, context: Context) {

    }
}
