import SwiftUI
import Secrets

extension Create {
    struct Second: View {
        @Binding var secret: Secret
        let reindex: (Int) -> Void
        @State private var name = ""
        @FocusState private var focus: Bool
        
        var body: some View {
            VStack {
                HStack {
                    Image(systemName: "character.textbox")
                        .font(.largeTitle)
                        .foregroundColor(.accentColor)
                    Text("Identify it with a name")
                    Spacer()
                }
                .padding()
                
                TextField(secret.name, text: $name)
                    .focused($focus)
                    .textInputAutocapitalization(.sentences)
                    .disableAutocorrection(!Defaults.correction)
                    .submitLabel(.done)
                    .foregroundColor(.accentColor)
                    .privacySensitive()
                    .padding()
                    .onChange(of: focus) {
                        if $0 == false {
                            Task {
                                await cloud.update(id: secret.id, name: name)
                            }
                        }
                    }
                
                Button {
                    focus.toggle()
                } label: {
                    Label("Name", systemImage: "rectangle.and.pencil.and.ellipsis")
                }
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
                
                Spacer()
                
                HStack(spacing: 40) {
                    Button {
                        reindex(0)
                    } label: {
                        Image(systemName: "arrow.left.circle.fill")
                    }
                    Button {
                        reindex(2)
                    } label: {
                        Image(systemName: "arrow.right.circle.fill")
                    }
                }
                .font(.largeTitle)
                .padding(.bottom, 80)
            }
            .frame(maxWidth: .greatestFiniteMagnitude)
        }
    }
}
