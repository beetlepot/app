import SwiftUI
import Secrets

extension Sidebar {
    struct Item: View {
        @Binding var selected: Int?
        let secret: Secret
        @State private var delete = false
        
        var body: some View {
            NavigationLink(tag: secret.id, selection: $selected) {
                Reveal(secret: secret)
            } label: {
                HStack {
                    if secret.favourite {
                        Image(systemName: "heart.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.caption2)
                            .foregroundColor(.accentColor)
                    }
                    Text(verbatim: secret.name)
                        .font(.footnote)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .privacySensitive()
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
                .padding(.vertical, 4)
            }
            .confirmationDialog("Delete secret?", isPresented: $delete) {
                Button("Delete", role: .destructive) {
                    selected = nil
                    delete = false
                    
                    Task {
                        await cloud.delete(id: secret.id)
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
            }
        }
    }
}
