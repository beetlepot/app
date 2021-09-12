import SwiftUI
import Secrets

extension Sidebar {
    struct Item: View {
        @Binding var selected: Int?
        let secret: Secret
        @State private var name = ""
        @State private var disabled = true
        @State private var delete = false
        @FocusState private var focus: Bool
        
        var body: some View {
            NavigationLink(tag: secret.id, selection: $selected) {
                Reveal(secret: secret)
            } label: {
                VStack(alignment: .leading) {
                    TextField(secret.name, text: $name)
                        .focused($focus)
                        .submitLabel(.done)
                        .onSubmit {
                            Task {
                                await cloud.update(id: secret.id, name: name)
                                await UNUserNotificationCenter.send(message: "Renamed secret!")
                            }
                        }
                        .disabled(disabled)
                        .privacySensitive()
                    if !secret.tags.isEmpty {
                        Tagger(secret: secret)
                            .privacySensitive()
                    }
                    HStack {
                        Text(verbatim: secret.date.formatted(.relative(presentation: .named, unitsStyle: .wide)))
                            .font(.footnote)
                            .foregroundStyle(.tertiary)
                        
                        Spacer()
                        
                        if secret.favourite {
                            Image(systemName: "heart.fill")
                                .font(.footnote)
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                .task {
                    name = secret.name
                }
            }
            .onChange(of: focus) {
                if $0 == false {
                    disabled = true
                    name = secret.name
                }
            }
            .confirmationDialog("Delete secret?", isPresented: $delete) {
                Button("Delete", role: .destructive) {
                    if UIDevice.pad && selected == secret.id {
                        selected = Index.capacity.rawValue
                    }
                    Task {
                        await cloud.delete(id: secret.id)
                        await UNUserNotificationCenter.send(message: "Deleted secret!")
                    }
                }
            }
            .swipeActions(edge: .leading) {
                Button {
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
                    delete = true
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .tint(.pink)
                Button {
                    disabled = false
                    DispatchQueue
                        .main
                        .asyncAfter(deadline: .now() + 1.2) {
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
