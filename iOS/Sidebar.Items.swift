import SwiftUI
import Secrets

extension Sidebar {
    struct Items: View {
        let filtered: [Secret]
        @State private var full = false
        @State private var created: Secret?
        @Environment(\.isSearching) private var searching
        
        var body: some View {
            List {
                if !searching {
                    Section {
                        Button(action: new) {
                            HStack {
                                Text("New secret")
                                Spacer()
                                Image(systemName: "plus.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .font(.title2)
                            }
                        }
                    }
                }
                
                Section {
                    ForEach(filtered, content: Item.init(secret:))
                }
            }
            .listStyle(.insetGrouped)
            .symbolRenderingMode(.hierarchical)
            .animation(.easeInOut(duration: 0.4), value: filtered)
            .sheet(item: $created) {
                Create(secret: $0)
            }
            .sheet(isPresented: $full, content: Full.init)
            .onOpenURL {
                guard $0.scheme == "beetle", $0.host == "create" else { return }
                new()
            }
        }
        
        private func new() {
            UIApplication.shared.hide()
            Task {
                do {
                    let id = try await cloud.secret()
                    created = await cloud.model[id]
                    await UNUserNotificationCenter.send(message: "Created a new secret!")
                } catch {
                    full = true
                }
            }
        }
    }
}
