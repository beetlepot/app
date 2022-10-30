import SwiftUI
import Secrets

struct Filters: View {
    @Binding var filter: Filter
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle(isOn: $filter.favourites) {
                        Label("Favourites only", systemImage: "heart.fill")
                            .font(.callout)
                            .foregroundColor(.primary)
                            .symbolRenderingMode(.multicolor)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .orange))
                }
                
                Section("Tags") {
                    ForEach(Tag.filtering(search: "")) { tag in
                        Button {
                            if filter.tags.contains(tag) {
                                filter.tags.remove(tag)
                            } else {
                                filter.tags.insert(tag)
                            }
                        } label: {
                            HStack {
                                Text(verbatim: tag.name)
                                    .privacySensitive()
                                    .font(.footnote)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: filter.tags.contains(tag) ? "checkmark.circle.fill" : "circle")
                                    .symbolRenderingMode(.hierarchical)
                                    .font(.callout)
                                    .foregroundColor(filter.tags.contains(tag) ? .init("Spot") : .init(.tertiaryLabel))
                            }
                        }
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Clear") {
                        filter = .init()
                    }
                    .font(.callout)
                    .foregroundStyle(.secondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.callout)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
