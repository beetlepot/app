import SwiftUI
import Secrets

extension Reveal.Content {
    struct Rename: View {
        @Binding var secret: Secret
        @State private var name = ""
        @Environment(\.dismiss) private var dismiss
        @FocusState private var focus: Bool
        
        var body: some View {
            NavigationView {
                List {
                    Section {
                        TextField(secret.name, text: $name)
                            .focused($focus)
                            .font(.body)
                            .textInputAutocapitalization(.sentences)
                            .disableAutocorrection(!Defaults.correction)
                            .submitLabel(.done)
                            .privacySensitive()
                            .onSubmit(submit)
                    }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Rename secret")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save", action: submit)
                        .font(.callout)
                        .foregroundColor(.blue)
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel", role: .cancel) {
                            dismiss()
                        }
                        .font(.callout)
                        .foregroundColor(.pink)
                    }
                }
            }
            .navigationViewStyle(.stack)
            .onAppear {
                name = secret.name
                DispatchQueue
                    .main
                    .async {
                        focus = true
                    }
            }
        }
        
        private func submit() {
            Task {
                await cloud.update(id: secret.id, name: name)
                await UNUserNotificationCenter.send(message: "Renamed secret!")
            }
            dismiss()
        }
    }
}
