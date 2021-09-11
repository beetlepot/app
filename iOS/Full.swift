import SwiftUI
import Secrets

struct Full: View {
    @State private var purchases = false
    
    var body: some View {
        VStack {
            Image(systemName: "lock.square")
                .resizable()
                .font(.largeTitle.weight(.ultraLight))
                .aspectRatio(contentMode: .fit)
                .frame(width: 80)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.init("Spot"))
                .padding(.bottom)
            Text("You reached the limit of secrets\nthat you can keep.\n")
                .foregroundColor(.primary)
                .font(.body)
            + Text("Purchase spots\nto add more secrets.")
                .foregroundColor(.secondary)
                .font(.callout)
            Button {
                purchases = true
            } label: {
                Text("In-App Purchases")
                    .frame(maxWidth: 220)
            }
            .buttonStyle(.borderedProminent)
            .padding(.vertical)
            .sheet(isPresented: $purchases, content: Purchases.init)
        }
        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        .background(Color(.secondarySystemBackground))
    }
}
