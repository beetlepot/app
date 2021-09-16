import SwiftUI
import Secrets

struct Sidebar: View {
    @State private var filter = Filter()
    
    var body: some View {
        Items(filter: $filter)
            .searchable(text: $filter.search, prompt: "Filter secrets by name")
            .navigationTitle("Secrets")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        UIApplication.shared.sheet()
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                    }
                    .tag(555)
                    NavigationLink(destination: Middlebar()) {
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
