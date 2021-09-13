import SwiftUI
import Secrets

struct Tags: View {
    let tags: Set<Tag>
    let action: (Tag) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List(Tag
                    .allCases
                    .sorted(), id: \.self) { tag in
                Button {
                    action(tag)
                } label: {
                    HStack {
                        Text(verbatim: "\(tag)")
                            .font(.callout)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: tags.contains(tag) ? "checkmark.circle.fill" : "circle")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title2)
                            .foregroundColor(tags.contains(tag) ? .init("Spot") : .init(.tertiaryLabel))
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
