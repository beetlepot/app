import SwiftUI
import StoreKit
import Secrets

extension Purchases {
    struct Item: View {
        let product: Product
        
        var body: some View {
            List {
                Text(verbatim: product.displayName)
                    .foregroundColor(.init("Spot"))
                    .font(.title3)
                    .listRowBackground(Color.clear)
                
                Text(verbatim: product.description)
                    .foregroundColor(.secondary)
                    .font(.callout)
                    .fixedSize(horizontal: false, vertical: true)
                    .listRowBackground(Color.clear)
                
                HStack {
                    Spacer()
                    Text(verbatim: product.displayPrice)
                        .font(.callout)
                        .foregroundStyle(.primary)
                    Spacer()
                }
                .listRowBackground(Color.clear)
                
                if product.id != Purchase.one.rawValue {
                    HStack {
                        Spacer()
                        Group {
                            Text("Save ")
                            + Text(Purchase(rawValue: product.id)!.save, format: .percent)
                        }
                        .foregroundColor(.orange)
                        .font(.footnote)
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }
                
                HStack {
                    Spacer()
                    Button {
                        Task {
                            await store.purchase(product)
                        }
                    } label: {
                        ZStack {
                            Capsule()
                                .fill(Color.accentColor)
                            HStack {
                                Spacer()
                                Text("Purchase")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                    }
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }
        }
    }
}
