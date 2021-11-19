import SwiftUI

struct Full: View {
    @State private var full = true
    @State private var purchases = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            if full {
                Image("full")
                    .resizable()
                    .font(.largeTitle.weight(.ultraLight))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.init("Spot"))
                    .padding(.bottom)
                Text(.init(Copy.full))
                    .foregroundColor(.secondary)
                    .font(.body)
                    .padding(.top)
                    .multilineTextAlignment(.leading)
            }
            
            Button {
                purchases = true
            } label: {
                Text("In-App Purchases")
                    .frame(maxWidth: 220)
            }
            .buttonStyle(.borderedProminent)
            .padding(.vertical)
            .sheet(isPresented: $purchases, content: Purchases.init)
            
            Button("Dismiss", role: .cancel) {
                dismiss()
            }
            .font(.callout)
            .foregroundStyle(.secondary)
            .padding(.bottom)
        }
        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        .background(Color(.secondarySystemBackground))
        .onReceive(cloud) {
            if $0.available {
                full = false
                purchases = false
                dismiss()
            }
        }
    }
}
