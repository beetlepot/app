import SwiftUI
import Secrets

struct Tags: View {
    let tags: Set<Tag>
    let action: (Tag) -> Void
    @State private var search = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List(Tag.filtering(search: search), id: \.self) { tag in
                Button {
                    action(tag)
                } label: {
                    HStack {
                        Text(verbatim: tag.name)
                            .privacySensitive()
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
        .navigationViewStyle(.stack)
    }
}
