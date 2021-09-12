import SwiftUI
import Secrets

struct Sidebar: View {
    let archive: Archive
    let proxy: ScrollViewProxy
    @State private var search = ""
    @State private var favourites = false
    @State private var selected: Int?
    @State private var onboard = false
    
    var body: some View {
        Content(search: $search, favourites: $favourites, selected: $selected, archive: archive)
            .searchable(text: $search)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        UIApplication.shared.hide()
                        favourites.toggle()
                    } label: {
                        Image(systemName: favourites ? "heart.fill" : "heart")
                            .symbolRenderingMode(.hierarchical)
                    }
                    .font(.callout)
                    
                    Button(action: new) {
                        Label("New secret", systemImage: "plus")
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .font(.callout)
                }
                
                ToolbarItem(placement: .keyboard) {
                    Button("Cancel", role: .cancel) {
                        UIApplication.shared.hide()
                    }
                    .font(.callout)
                    .tint(.pink)
                }
            }
            .onOpenURL {
                guard $0.scheme == "beetle", $0.host == "create" else { return }
                new()
            }
            .sheet(isPresented: $onboard, onDismiss: {
                Defaults.onboarded = true
            }) {
                Onboard(selected: $selected)
            }
            .task {
                if !Defaults.onboarded {
                    onboard = true
                }
            }
    }
    
    private func new() {
        UIApplication.shared.hide()
        if archive.available {
            Task {
                let selected = await cloud.secret()
                proxy.scrollTo(selected)
                self.selected = selected
            }
        } else {
            proxy.scrollTo(Index.full.rawValue)
            selected = Index.full.rawValue
        }
    }
}
