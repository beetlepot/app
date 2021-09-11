import SwiftUI

struct Purchases: View {
    @State private var state = Store.Status.loading
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                switch state {
                case .loading:
                    Image(systemName: "hourglass")
                        .resizable()
                        .font(.largeTitle.weight(.light))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .symbolVariant(.circle)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color("Spot"), Color.accentColor)
                        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
                case let .error(error):
                    VStack {
                        Text(verbatim: error)
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: 300)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                    }
                    .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
                case let .products(products):
                    TabView {
                        ForEach(products, id: \.self) {
                            Item(product: $0)
                        }
                    }
                    .tabViewStyle(.page)
                }
            }
            .navigationTitle("In-App Puchases")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dismiss", role: .cancel) {
                        dismiss()
                    }
                    .font(.callout)
                    .foregroundColor(.pink)
                }
            }
        }
        .navigationViewStyle(.stack)
        .onReceive(store.status) {
            state = $0
        }
        .task {
            UIPageControl.appearance().currentPageIndicatorTintColor = .init(named: "Spot")
            UIPageControl.appearance().pageIndicatorTintColor = .quaternaryLabel
            await store.load()
        }
    }
}
