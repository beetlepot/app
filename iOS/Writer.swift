import SwiftUI
import Combine

struct Writer: View, Equatable {
    let id: Int
    @State private var name = ""
    @Environment(\.dismiss) private var dismiss
    private let submit = PassthroughSubject<Void, Never>()
    
    var body: some View {
        Representable(id: id, submit: submit)
            .privacySensitive()
            .navigationTitle(name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        UIApplication.shared.hide()
                        dismiss()
                    }
                    .font(.footnote)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .tint(.pink)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        submit.send()
                        dismiss()
                    }
                    .font(.footnote)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                }
            }
            .onReceive(cloud) {
                name = $0[id].name
            }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}
