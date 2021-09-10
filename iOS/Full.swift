import SwiftUI
import Secrets

struct Full: View {
    @Binding var selected: Int?
    
    var body: some View {
        VStack {
            Image(systemName: "lock.square")
                .resizable()
                .font(.largeTitle.weight(.ultraLight))
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.quaternary)
                .padding(.bottom)
            Text("You reached the limit of secrets\nthat you can keep.\n")
                .foregroundColor(.primary)
                .font(.body)
            + Text("Purchase more capacity\nto create a new secret.")
                .foregroundColor(.secondary)
                .font(.callout)
            Button {
                selected = Sidebar.Index.capacity.rawValue
            } label: {
                Text("In-App Purchases")
                    .frame(maxWidth: 240)
            }
            .buttonStyle(.borderedProminent)
            .padding(.vertical)
        }
        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        .background(Color(.systemFill))
    }
}
