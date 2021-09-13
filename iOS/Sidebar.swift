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
    }
}
