import SwiftUI
import Combine

extension Writer {
    struct Representable: UIViewRepresentable {
        let id: Int
        let submit: PassthroughSubject<Void, Never>
        
        func makeUIView(context: Context) -> Text {
            .init(id: id, submit: submit)
        }
        
        func updateUIView(_: Text, context: Context) { }
    }
}
