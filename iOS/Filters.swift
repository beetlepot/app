import SwiftUI
import Secrets

struct Filters: UIViewControllerRepresentable {
    @Binding var filter: Filter
    
    func makeUIViewController(context: Context) -> Controller {
        .init(rootView: Content(filter: $filter))
    }
    
    func updateUIViewController(_: Controller, context: Context) {
        
    }
}
