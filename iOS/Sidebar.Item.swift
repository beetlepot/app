import SwiftUI
import Secrets

extension Sidebar {
    struct Item: View {
        @Binding var selected: Int?
        let index: Int
        let secret: Secret
        let tags: Int
        @State private var name = ""
        @State private var disabled = true
        @State private var delete = false
        @FocusState private var focus: Bool
        
        var body: some View {
            NavigationLink(tag: index, selection: $selected) {
                Reveal(index: index, secret: secret)
            } label: {
                HStack(spacing: 0) {
                    if secret.favourite {
                        Image(systemName: "heart.fill")
                            .font(.caption2)
                            .foregroundColor(.accentColor)
                            .frame(width: 20)
                            .padding(.trailing, 5)
                    } else {
                        Spacer()
                            .frame(width: 25)
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        TextField(secret.name, text: $name)
                            .focused($focus)
                            .submitLabel(.done)
                            .onSubmit {
                                Task {
                                    await cloud.update(index: index, name: name)
                                    await UNUserNotificationCenter.send(message: "Renamed secret!")
                                }
                            }
                            .disabled(disabled)
                            .privacySensitive()
                            .padding(.bottom, 3)
                        if !secret.tags.isEmpty {
                            Tagger(secret: secret, tags: tags)
                                .privacySensitive()
                                .padding(.vertical, 5)
                        }
                        Text(verbatim: secret.date.formatted(.relative(presentation: .named, unitsStyle: .wide)))
                            .font(.footnote)
                            .foregroundStyle(.tertiary)
                            .padding(.top, 3)
                    }
                    Spacer()
                }
                .onAppear {
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
                    if UIDevice.pad && selected == index {
                        selected = Index.capacity.rawValue
                    }
                    Task {
                        await cloud.delete(index: index)
                        await UNUserNotificationCenter.send(message: "Deleted secret!")
                    }
                }
            }
            .swipeActions(edge: .leading) {
                Button {
                    Task {
                        await cloud.update(index: index, favourite: !secret.favourite)
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
