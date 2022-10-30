import SwiftUI
import Secrets

struct Tags: View {
    @Binding var secret: Secret
    @State private var search = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List(Tag.filtering(search: search)) { tag in
                Button {
                    Task
                        .detached(priority: .utility) {
                            if secret.tags.contains(tag) {
                                await cloud.remove(id: secret.id, tag: tag)
                            } else {
                                await cloud.add(id: secret.id, tag: tag)
                            }
                        }
                } label: {
                    HStack {
                        Text(verbatim: tag.name)
                            .privacySensitive()
                            .font(.callout)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: secret.tags.contains(tag) ? "checkmark.circle.fill" : "circle")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title2)
                            .foregroundColor(secret.tags.contains(tag) ? .init("Spot") : .init(.tertiaryLabel))
                    }
                    .padding(.vertical, 5)
                }
            }
            .searchable(text: $search)
            .listStyle(.insetGrouped)
            .navigationTitle("Tags")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.callout)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .onReceive(cloud) {
            secret = $0[secret.id]
        }
    }
}
