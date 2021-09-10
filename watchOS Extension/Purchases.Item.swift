import SwiftUI
import StoreKit
import Secrets

extension Purchases {
    struct Item: View {
        let product: Product
        
        var body: some View {
            List {
                Section {
                    Group {
                        Text(verbatim: product.displayName)
                            .foregroundColor(.primary)
                            .font(.title3)
                        + Text(verbatim: "\n" + product.description)
                            .foregroundColor(.secondary)
                            .font(.callout)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    HStack {
                        Spacer()
                        Text(verbatim: product.displayPrice)
                            .font(.footnote.monospacedDigit())
                            .foregroundStyle(.primary)
                        if product.id != Purchase.one.rawValue {
                            Group {
                                Text("Save ")
                                + Text(Purchase(rawValue: product.id)!.save, format: .percent)
                            }
                            .foregroundColor(.orange)
                            .font(.footnote)
                        }
                        Spacer()
                    }
                }
                .listRowBackground(Color.clear)
                
                Section {
                    Button("Purchase") {
                        Task {
                            await store.purchase(product)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.footnote)
                }
                .listRowBackground(Color.clear)
            }
        }
    }
}
