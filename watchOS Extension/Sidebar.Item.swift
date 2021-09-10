import SwiftUI
import UserNotifications
import Secrets

extension Sidebar {
    struct Item: View {
        @Binding var selected: Int?
        let index: Int
        let secret: Secret
        @State private var delete = false
        
        var body: some View {
            NavigationLink(tag: index, selection: $selected) {
                Reveal(index: index, secret: secret)
            } label: {
                if secret.favourite {
                    Image(systemName: "heart.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.caption2)
                        .foregroundColor(.accentColor)
                }
                Text(verbatim: secret.name)
                    .font(.callout)
                    .fixedSize(horizontal: false, vertical: true)
                    .privacySensitive()
            }
            .confirmationDialog("Delete secret?", isPresented: $delete) {
                Button("Delete", role: .destructive) {
                    selected = nil
                    delete = false
                    
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
            }
        }
    }
}
