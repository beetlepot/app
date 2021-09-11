import SwiftUI
import Secrets

struct Sidebar: View {
    @Binding var search: String
    @Binding var selected: Int?
    let archive: Archive
    let new: () -> Void
    @State private var onboard = false
    @State private var favourites = false
    @State private var filtered = [Int]()
    @Environment(\.isSearching) var searching
    
    var body: some View {
        GeometryReader { geo in
            List {
                Section("Secrets") {
                    ForEach(filtered, id: \.self) {
                        Item(selected: $selected, secret: archive[$0], tags: .init(geo.size.width / 110))
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
            .navigationTitle("Beetle")
            .navigationBarTitleDisplayMode(.inline)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    UIApplication.shared.hide()
                    favourites.toggle()
                } label: {
                    Image(systemName: favourites ? "heart.fill" : "heart")
                        .symbolRenderingMode(.hierarchical)
                }
                
                Button(action: new) {
                    Label("New secret", systemImage: "plus")
                }
                .buttonStyle(.borderedProminent)
            }
            
            ToolbarItem(placement: .keyboard) {
                Button(role: .cancel) {
                    UIApplication.shared.hide()
                } label: {
                    Text("Cancel")
                        .font(.footnote)
                }
                .tint(.pink)
            }
        }
        .sheet(isPresented: $onboard, onDismiss: {
            Defaults.onboarded = true
        }) {
            Onboard(selected: $selected)
        }
        .onAppear {
            if !Defaults.onboarded {
                onboard = true
            }
            filtered = archive.filter(favourites: favourites, search: search)
        }
        .onChange(of: archive) {
            filtered = $0.filter(favourites: favourites, search: search)
        }
        .onChange(of: favourites) { favourites in
            withAnimation(.easeInOut(duration: 0.35)) {
                filtered = archive.filter(favourites: favourites, search: search)
            }
        }
        .onChange(of: search) { search in
            withAnimation(.easeInOut(duration: 0.35)) {
                filtered = archive.filter(favourites: favourites, search: search)
            }
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
