import SwiftUI
import Secrets

struct Sidebar: View {
    @State private var filtered = [Secret]()
    @State private var filter = Filter()
    @State private var filters = false
    
    var body: some View {
        Items(filtered: filtered)
            .searchable(text: $filter.search, prompt: "Filter secrets by name")
            .navigationTitle("Secrets")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        filters = true
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(filter.tags.isEmpty && !filter.favourites ? .accentColor : .pink) 
                    }
                    .sheet(isPresented: $filters) {
                        Filters(filter: $filter)
                            .edgesIgnoringSafeArea(.all)
                    }
                    
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
            .onReceive(cloud) {
                filtered = $0.filtering(with: filter)
            }
            .onChange(of: filter) { filter in
                Task {
                    filtered = await cloud.model.filtering(with: filter)
                }
            }
    }
}
