import SwiftUI
import Secrets

extension Sidebar {
    struct Items: View {
        let filtered: [Secret]
        @State private var pop: Pop?
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
            .sheet(item: $pop, content: modal)
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
                    pop = .create(id)
                    await UNUserNotificationCenter.send(message: "Created a new secret!")
                } catch {
                    pop = .full
                }
            }
        }
        
        @ViewBuilder private func modal(_ pop: Pop) -> some View {
            switch pop {
            case .full:
                Full()
            case let .create(id):
                Create(id: id)
            }
        }
    }
}
