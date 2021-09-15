import SwiftUI
import Combine

struct Writer: View {
    let id: Int
    @Binding var editing: Bool
    @State private var name = ""
    private let submit = PassthroughSubject<Void, Never>()
    
    var body: some View {
        Representable(id: id, submit: submit)
            .privacySensitive()
            .navigationTitle(name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .privacySensitive()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        UIApplication.shared.hide()
                        dismiss()
                    }
                    .font(.callout)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .tint(.pink)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        submit.send()
                        dismiss()
                    }
                    .font(.callout)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                }
            }
            .onReceive(cloud.archive) {
                name = $0[id].name
            }
    }
    
    private func dismiss() {
        withAnimation(.easeInOut(duration: 0.5)) {
            editing = false
        }
    }
}
