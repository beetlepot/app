import SwiftUI
import Combine
import Secrets

struct Writer: View {
    let index: Int
    let secret: Secret
    @Binding var editing: Bool
    private let submit = PassthroughSubject<Void, Never>()
    
    var body: some View {
        Representable(index: index, secret: secret, submit: submit)
            .privacySensitive()
            .navigationTitle(secret.name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .privacySensitive()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        UIApplication.shared.hide()
                        dismiss()
                    }
                    .font(.footnote)
                    .buttonStyle(.borderless)
                    .tint(.pink)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        submit.send()
                        dismiss()
                    }
                    .font(.footnote)
                    .buttonStyle(.borderedProminent)
                }
            }
    }
    
    private func dismiss() {
        withAnimation(.easeInOut(duration: 0.5)) {
            editing = false
        }
    }
}
