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
                Section("Secrets") {
                    ForEach(filtered, id: \.self) {
                        Item(selected: $selected, secret: archive[$0])
                    }
                }
                
                if !searching {
                    app
                    help
                    
                    NavigationLink(tag: Index.full.rawValue, selection: $selected, destination: Full.init) {
                        
                    }
                    .listRowSeparator(.hidden)
                    .hidden()
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.sidebar)
            .symbolRenderingMode(.hierarchical)
            .animation(.easeInOut(duration: 0.4), value: filtered)
            .navigationTitle("Beetle")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
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
        
        private var app: some View {
            Section("App") {
                NavigationLink(tag: Index.settings.rawValue, selection: $selected) {
                    Settings()
                } label: {
                    Label("Settings", systemImage: "slider.horizontal.3")
                }
                
                NavigationLink(tag: Index.capacity.rawValue, selection: $selected) {
                    Capacity(archive: archive)
                } label: {
                    Label("Capacity", systemImage: "lock.square.stack")
                }
            }
            .font(.callout)
        }
        
        private var help: some View {
            Section("Help") {
                NavigationLink(tag: Index.markdown.rawValue, selection: $selected) {
                    Info(title: "Markdown", text: Copy.markdown)
                } label: {
                    Label("Markdown", systemImage: "square.text.square")
                }
                
                NavigationLink(tag: Index.privacy.rawValue, selection: $selected) {
                    Info(title: "Privacy policy", text: Copy.privacy)
                } label: {
                    Label("Privacy policy", systemImage: "hand.raised")
                }
                
                NavigationLink(tag: Index.terms.rawValue, selection: $selected) {
                    Info(title: "Terms and conditions", text: Copy.terms)
                } label: {
                    Label("Terms and conditions", systemImage: "doc.plaintext")
                }
            }
            .font(.callout)
        }
    }
}
