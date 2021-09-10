import SwiftUI
import Secrets

struct Tags: View {
    let index: Int
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
                            await cloud.remove(index: index, tag: tag)
                        } else {
                            await cloud.add(index: index, tag: tag)
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
                            .foregroundColor(secret.tags.contains(tag) ? .orange : .init(.tertiaryLabel))
                    }
                    .padding(.vertical, 5)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Tags")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .font(.footnote)
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }
}
