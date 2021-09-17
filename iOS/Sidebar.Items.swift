import SwiftUI
import Secrets

extension Sidebar {
    struct Items: View {
        @Binding var filter: Filter
        @State private var pop: Pop?
        @State private var filtered = [Secret]()
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
                    
                    DisclosureGroup("Filter") {
                        Toggle(isOn: $filter.favourites) {
                            Label("Favourites", systemImage: "heart")
                                .foregroundColor(.primary)
                                .symbolRenderingMode(.multicolor)
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .orange))
                        
                        Button {
                            pop = .tags
                        } label: {
                            HStack {
                                Text("Tags")
                                    .foregroundColor(.accentColor)
                                Spacer()
                                Image(systemName: "tag")
                                    .foregroundColor(.accentColor)
                                    .symbolRenderingMode(.multicolor)
                                    .font(.body)
                            }
                        }
                        
                        if !filter.tags.isEmpty {
                            Tagger(tags: filter.tags.list)
                                .listRowSeparator(.hidden)
                        }
                        
                        if !filter.tags.isEmpty || filter.favourites {
                            Button("Clear filters") {
                                filter = .init()
                            }
                            .font(.footnote)
                            .buttonStyle(.bordered)
                            .foregroundColor(.primary)
                        }
                    }
                    .font(.callout)
                    .foregroundColor(filter.tags.isEmpty && !filter.favourites ? .secondary : .pink)
                    .listRowBackground(Color.clear)
//                    .listRowSeparator(.hidden)
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
            .onReceive(cloud) {
                filtered = $0.filtering(with: filter)
            }
            .onChange(of: filter) { filter in
                Task {
                    filtered = await cloud.model.filtering(with: filter)
                }
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
            case .tags:
                Tags(tags: filter.tags) { tag in
                    if filter.tags.contains(tag) {
                        filter.tags.remove(tag)
                    } else {
                        filter.tags.insert(tag)
                    }
                }
            case .full:
                Full()
            case let .create(id):
                Create(id: id)
            }
        }
    }
}
