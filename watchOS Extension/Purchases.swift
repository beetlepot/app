import SwiftUI

struct Purchases: View {
    @State private var status = Store.Status.loading
    
    var body: some View {
        VStack {
            switch status {
            case .loading:
                Image(systemName: "hourglass")
                    .font(.largeTitle)
                    .symbolVariant(.circle)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.accentColor, Color("Spot"))
            case let .error(error):
                Text(verbatim: error)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
            case let .products(products):
                TabView {
                    ForEach(products, content: Item.init)
                }
            }
        }
        .navigationTitle("Purchases")
        .onReceive(store.status) {
            status = $0
        }
        .task {
            await store.load()
        }
    }
}
