import SwiftUI
import Secrets

extension Sidebar {
    struct Item: View {
        let secret: Secret
        @State private var name = ""
        @State private var disabled = true
        @State private var delete = false
        @FocusState private var focus: Bool
        
        var body: some View {
            NavigationLink(destination: Reveal(secret: secret)) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        TextField(secret.name, text: $name)
                            .focused($focus)
                            .font(.body)
                            .textInputAutocapitalization(.sentences)
                            .disableAutocorrection(!Defaults.correction)
                            .submitLabel(.done)
                            .privacySensitive()
                            .onSubmit {
                                Task {
                                    await cloud.update(id: secret.id, name: name)
                                    await UNUserNotificationCenter.send(message: "Renamed secret!")
                                }
                            }
                            .disabled(disabled)
                        if disabled && secret.favourite {
                            Image(systemName: "heart.fill")
                                .font(.footnote)
                                .foregroundStyle(.tertiary)
                        }
                    }
                    if disabled && !secret.tags.isEmpty {
                        Tagger(tags: secret.tags.list)
                            .privacySensitive()
                    }
                }
                .padding(.vertical, 8)
            }
            .onAppear {
                name = secret.name
            }
            .onChange(of: secret) {
                name = $0.name
            }
            .onChange(of: focus) {
                if $0 == false {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        disabled = true
                    }

                    name = secret.name
                }
            }
            .confirmationDialog("Delete secret?", isPresented: $delete) {
                Button("Delete", role: .destructive) {
                    Task {
                        await cloud.delete(id: secret.id)
                        await UNUserNotificationCenter.send(message: "Deleted secret!")
                    }
                }
            }
            .swipeActions(edge: .leading) {
                Button {
                    UIApplication.shared.hide()
                    Task {
                        await cloud.update(id: secret.id, favourite: !secret.favourite)
                    }
                } label: {
                    Label("Favourite", systemImage: secret.favourite ? "heart.slash" : "heart")
                }
                .tint(secret.favourite ? .gray : .accentColor)
            }
            .swipeActions {
                Button {
                    UIApplication.shared.hide()
                    delete = true
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .tint(.pink)
                Button {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        disabled = false
                    }
                    
                    DispatchQueue
                        .main
                        .asyncAfter(deadline: .now() + 1) {
                            focus = true
                        }
                } label: {
                    Label("Rename", systemImage: "pencil")
                }
                .tint(.orange)
            }
        }
    }
}
