import SwiftUI
import Secrets

extension Sidebar {
    struct Items: View {
        let filtered: [Secret]
        @State private var create = false
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
            .sheet(isPresented: $create, content: Validate.init)
            .onOpenURL {
                guard $0.scheme == "beetle", $0.host == "create" else { return }
                new()
            }
        }
        
        private func new() {
            UIApplication.shared.hide()
            create = true
        }
    }
}
