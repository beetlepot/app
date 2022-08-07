import SwiftUI

struct Empty: View {
    @State private var empty = true
    
    var body: some View {
        VStack {
            Image("Logo")
                .foregroundColor(.secondary)
            Text(empty ? "Create your first secret" : "Select a secret from the list\nor create a new one")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        .background(Color(.secondarySystemBackground))
        .onReceive(cloud) {
            empty = $0.count == 0
        }
    }
}
