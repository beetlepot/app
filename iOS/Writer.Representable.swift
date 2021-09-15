import SwiftUI
import Combine

extension Writer {
    struct Representable: UIViewRepresentable {
        let id: Int
        let submit: PassthroughSubject<Void, Never>
        
        func makeCoordinator() -> Coordinator {
            .init(id: id, submit: submit)
        }
        
        func makeUIView(context: Context) -> Coordinator {
            context.coordinator
        }
        
        func updateUIView(_: Coordinator, context: Context) { }
    }
}
