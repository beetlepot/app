import SwiftUI
import Secrets

struct Edit: View {
    @State var name: String
    @State var payload: String
    let index: Int
    let secret: Secret
    
    var body: some View {
        List {
            TextField("Name", text: $name)
                .onSubmit {
                    Task {
                        await cloud.update(index: index, name: name)
                    }
                }
                .privacySensitive()

            TextField("Secret", text: $payload)
                .onSubmit {
                    Task {
                        await cloud.update(index: index, payload: payload)
                    }
                }
                .privacySensitive()
            
            ForEach(Tag
                    .allCases
                    .sorted(), id: \.self) { tag in
                Button {
                    Task {
                        if secret.tags.contains(tag) {
                            await cloud.remove(index: index, tag: tag)
                        } else {
                            await cloud.add(index: index, tag: tag)
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
                            .foregroundColor(secret.tags.contains(tag) ? .orange : .secondary)
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .navigationTitle("Edit")
    }
}
