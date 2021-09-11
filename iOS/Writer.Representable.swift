import SwiftUI
import Combine
import Secrets

extension Writer {
    struct Representable: UIViewRepresentable {
        let secret: Secret
        let submit: PassthroughSubject<Void, Never>
        
        func makeCoordinator() -> Coordinator {
            .init(secret: secret, submit: submit)
        }
        
        func makeUIView(context: Context) -> Coordinator {
            context.coordinator
        }
        
        func updateUIView(_: Coordinator, context: Context) { }
    }
}
