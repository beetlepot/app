import SwiftUI
import Secrets

struct Full: View {
    let archive: Archive
    @State private var purchases = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            if !archive.available {
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
            .font(.footnote)
            .foregroundStyle(.secondary)
            .padding(.bottom)
        }
        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        .background(Color(.secondarySystemBackground))
        .onChange(of: archive) {
            if $0.available {
                purchases = false
                dismiss()
            }
        }
    }
}
