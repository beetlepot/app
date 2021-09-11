import SwiftUI
import Secrets

struct Edit: View {
    @State var name: String
    @State var payload: String
    let secret: Secret
    
    var body: some View {
        List {
            TextField("Name", text: $name)
                .onSubmit {
                    Task {
                        await cloud.update(id: secret.id, name: name)
                    }
                }
                .privacySensitive()

            TextField("Secret", text: $payload)
                .onSubmit {
                    Task {
                        await cloud.update(id: secret.id, payload: payload)
                    }
                }
                .privacySensitive()
            
            ForEach(Tag
                    .allCases
                    .sorted(), id: \.self) { tag in
                Button {
                    Task {
                        if secret.tags.contains(tag) {
                            await cloud.remove(id: secret.id, tag: tag)
                        } else {
                            await cloud.add(id: secret.id, tag: tag)
                        }
                    }
                } label: {
                    HStack {
                        Text(verbatim: "\(tag)")
                            .font(.caption2)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: secret.tags.contains(tag) ? "checkmark.circle.fill" : "circle")
                            .symbolRenderingMode(.hierarchical)
                            .font(.callout)
                            .foregroundColor(secret.tags.contains(tag) ? .init("Spot") : .secondary)
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .navigationTitle("Edit")
    }
}
