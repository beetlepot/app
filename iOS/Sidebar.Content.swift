import SwiftUI
import Secrets

extension Sidebar {
    struct Content: View {
        @Binding var search: String
        @Binding var favourites: Bool
        @Binding var selected: Int?
        let archive: Archive
        @State private var filtered = [Int]()
        @Environment(\.isSearching) var searching
        
        var body: some View {
            List {
//                Section("Secrets") {
//
//                }
                ForEach(filtered, id: \.self) {
                    Item(selected: $selected, secret: archive[$0])
                        .id($0)
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
            .listStyle(.sidebar)
            .symbolRenderingMode(.hierarchical)
            .animation(.easeInOut(duration: 0.4), value: filtered)
            .task {
                filtered = archive.filter(favourites: favourites, search: search)
            }
            .onChange(of: archive) {
                filtered = $0.filter(favourites: favourites, search: search)
            }
            .onChange(of: favourites) { favourites in
                filtered = archive.filter(favourites: favourites, search: search)
            }
            .onChange(of: search) { search in
                filtered = archive.filter(favourites: favourites, search: search)
            }
        }
    }
}
