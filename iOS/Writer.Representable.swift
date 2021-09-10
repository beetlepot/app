import SwiftUI
import Combine
import Secrets

extension Writer {
    struct Representable: UIViewRepresentable {
        let index: Int
        let secret: Secret
        let submit: PassthroughSubject<Void, Never>
        
        func makeCoordinator() -> Coordinator {
            .init(index: index, secret: secret, submit: submit)
        }
        
        func makeUIView(context: Context) -> Coordinator {
            context.coordinator
        }
        
        func updateUIView(_: Coordinator, context: Context) { }
    }
}
