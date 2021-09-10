import SwiftUI
import Secrets

struct Empty: View {
    let archive: Archive
    
    var body: some View {
        VStack {
            Image(systemName: "lock.square")
                .resizable()
                .font(.largeTitle.weight(.ultraLight))
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .foregroundStyle(.quaternary)
            Text(archive.count == 0 ? "Create your first secret" : "Select a secret from the list\nor create a new one")
                .font(.callout)
                .foregroundStyle(.tertiary)
                .padding(.top)
        }
        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        .background(Color(.systemFill))
    }
}
