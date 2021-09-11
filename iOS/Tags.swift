import SwiftUI
import Secrets

struct Tags: View {
    let secret: Secret
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List(Tag
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
            .listStyle(.insetGrouped)
            .navigationTitle("Tags")
            .navigationBarTitleDisplayMode(.large)
            .navigationViewStyle(.stack)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.callout)
                }
            }
        }
    }
}
