import SwiftUI
import Secrets

extension Sidebar {
    struct Items: View {
        @Binding var filter: Filter
        let archive: Archive
        @State private var filtered = [Int]()
        @State private var pop: Pop?
        @Environment(\.isSearching) private var searching
        
        var body: some View {
            List {
                if !searching {
                    Section {
                        Button(action: new) {
                            Label("New secret", systemImage: "plus.circle.fill")
                                .symbolRenderingMode(.hierarchical)
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
                            Label("Tags", systemImage: "tag")
                                .foregroundColor(.accentColor)
                                .symbolRenderingMode(.multicolor)
                        }
                        
                        if !filter.tags.isEmpty {
                            Tagger(tags: filter.tags.list)
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
                    .listRowSeparator(.hidden)
                }
                
                Section {
                    ForEach(filtered, id: \.self) {
                        Item(secret: archive[$0])
                    }
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
            .onAppear {
                filtered = archive.filtering(with: filter)
            }
            .onChange(of: archive) {
                filtered = $0.filtering(with: filter)
            }
            .onChange(of: filter) {
                filtered = archive.filtering(with: $0)
            }
        }
        
        private func new() {
            UIApplication.shared.hide()
            if archive.available {
                Task {
                    let id = await cloud.secret()
                    pop = .create(id)
                    await UNUserNotificationCenter.send(message: "Created a new secret!")
                }
            } else {
                pop = .full
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
                Full(archive: archive)
            case let .create(id):
                Create(secret: archive[id])
            }
        }
    }
}
