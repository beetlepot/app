import SwiftUI
import StoreKit
import Secrets

extension Purchases {
    struct Item: View {
        let product: Product
        
        var body: some View {
            VStack {
                Image(product.id)
                Group {
                    Text(verbatim: product.displayName)
                        .foregroundColor(.primary)
                        .font(.title)
                    + Text(verbatim: "\n" + product.description)
                        .foregroundColor(.secondary)
                        .font(.callout)
                }
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: 200)
                .padding(.bottom)
                HStack {
                    Text(verbatim: product.displayPrice)
                        .font(.body.monospacedDigit())
                    if product.id != Purchase.one.rawValue, let percent = Purchase(rawValue: product.id)?.save {
                        Group {
                            Text("Save ")
                            + Text(percent, format: .percent)
                        }
                        .foregroundColor(.orange)
                        .font(.callout.bold())
                    }
                }
                .padding(.top)
                Button {
                    Task {
                        await store.purchase(product)
                    }
                } label: {
                    Text("Purchase")
                        .font(.callout)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .padding(.bottom)
            }
        }
    }
}
