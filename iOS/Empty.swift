import SwiftUI
import Secrets

struct Empty: View {
    let empty: Bool
    
    var body: some View {
        VStack {
            Image("Logo")
            Text(empty ? "Create your first secret" : "Select a secret from the list\nor create a new one")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        .background(Color(.secondarySystemBackground))
    }
}
