import SwiftUI
import StoreKit
import Secrets

extension Capacity.Content {
    struct Item: View {
        let product: Product
        
        var body: some View {
            VStack {
                HStack {
                    Image(product.id)
                        .padding(.trailing)
                    Group {
                        Text(verbatim: product.displayName)
                            .foregroundColor(.primary)
                            .font(.title)
                        + Text(verbatim: "\n" + product.description)
                            .foregroundColor(.secondary)
                            .font(.callout)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
                .padding(.horizontal)
                .frame(maxWidth: 300)
                .padding(.vertical)
                HStack {
                    Spacer()
                    Text(verbatim: product.displayPrice)
                        .font(.body.monospacedDigit())
                        .foregroundStyle(.secondary)
                    if product.id != Purchase.one.rawValue {
                        Group {
                            Text("Save ")
                            + Text(Purchase(rawValue: product.id)!.save, format: .percent)
                        }
                        .foregroundColor(.orange)
                        .font(.callout.bold())
                    }
                    Spacer()
                }
                .padding(.top)
                Button("Purchase") {
                    Task {
                        await store.purchase(product)
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom)
            }
        }
    }
}
