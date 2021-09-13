import SwiftUI
import Secrets

extension Sidebar {
    struct Items: View {
        @Binding var filter: Filter
        let archive: Archive
        @State private var filtered = [Int]()
        @State private var tags = false
        @Environment(\.isSearching) private var searching
        
        var body: some View {
            List {
                if !searching {
                    Section {
                        Text("hello world")
                    }
                    
                    DisclosureGroup("Filter") {
                        Toggle(isOn: $filter.favourites) {
                            Label("Favourites", systemImage: "heart")
                                .foregroundColor(.primary)
                                .symbolRenderingMode(.multicolor)
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .orange))
                        
                        Button {
                            tags = true
                        } label: {
                            Label("Tags", systemImage: "tag")
                                .foregroundColor(.accentColor)
                                .symbolRenderingMode(.multicolor)
                        }
                        .sheet(isPresented: $tags) {
                            Tags(tags: filter.tags) { tag in
                                if filter.tags.contains(tag) {
                                    filter.tags.remove(tag)
                                } else {
                                    filter.tags.insert(tag)
                                }
                            }
                        }
                        
                        if !filter.tags.isEmpty {
                            Tagger(tags: filter.tags.list)
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .font(.callout)
                    .foregroundColor(filter.tags.isEmpty && !filter.favourites ? .secondary : .pink)
                }
                
                Section {
                    ForEach(filtered, id: \.self) {
                        Item(secret: archive[$0])
                    }
                }
                
//                if !searching {
//                    app
//                    help
//                    
//                    NavigationLink(tag: Index.full.rawValue, selection: $selected, destination: Full.init) {
//                        
//                    }
//                    .id(Index.full.rawValue)
//                    .listRowSeparator(.hidden)
//                    .hidden()
//                    .listRowBackground(Color.clear)
//                }
            }
            .listStyle(.insetGrouped)
            .symbolRenderingMode(.hierarchical)
            .animation(.easeInOut(duration: 0.4), value: filtered)
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
    }
}
