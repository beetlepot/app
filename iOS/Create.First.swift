import SwiftUI
import Secrets

extension Create {
    struct First: View, Equatable {
        @Binding var secret: Secret
        let reindex: (Int) -> Void
        @State private var payload = false
        
        var body: some View {
            VStack {
                HStack {
                    Image(systemName: "lock.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.accentColor)
                    Text("Enter your secret")
                    Spacer()
                }
                .padding()
                
                Text(verbatim: secret.payload.isEmpty ? "This secret is empty" : secret.payload)
                    .privacySensitive()
                    .foregroundColor(secret.payload.isEmpty ? .secondary : .accentColor)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .padding()
                
                Button {
                    payload = true
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
                .buttonStyle(.bordered)
                .padding(.vertical)
                .sheet(isPresented: $payload) {
                    NavigationView {
                        Writer(id: secret.id) {
                            payload = false
                        }
                    }
                    .navigationViewStyle(.stack)
                }
                
                Spacer()
                
                Button {
                    reindex(1)
                } label: {
                    Image(systemName: "arrow.right")
                }
                .padding(.bottom, 80)
            }
            .frame(maxWidth: .greatestFiniteMagnitude)
            .tag(0)
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            true
        }
    }
}
