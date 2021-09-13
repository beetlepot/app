import SwiftUI
import Secrets

struct Sidebar: View {
    let archive: Archive
    @State private var filter = Filter()
    
    var body: some View {
        Items(filter: $filter, archive: archive)
            .searchable(text: $filter.search, prompt: "Filter secrets by name")
            .navigationTitle("Secrets")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {
//                        UIApplication.shared.hide()
//                        favourites.toggle()
//                    } label: {
//                        Image(systemName: favourites ? "heart.fill" : "heart")
//                            .symbolRenderingMode(.hierarchical)
//                    }
//                    .font(.callout)
                    
//                    Button(action: new) {
//                        Label("New secret", systemImage: "plus")
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .buttonBorderShape(.capsule)
//                    .font(.callout)
                    
                    NavigationLink(destination: Middlebar(archive: archive)) {
                        Label("Menu", systemImage: "ellipsis.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                    }
                }
                
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
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
    }
    
    private func new() {
        UIApplication.shared.hide()
        if archive.available {
//            Task {
//                let selected = await cloud.secret()
//            }
        } else {
//            proxy.scrollTo(Index.full.rawValue)
//            selected = Index.full.rawValue
        }
    }
}
