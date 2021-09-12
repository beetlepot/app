import SwiftUI
import Secrets

struct Reveal: View {
    let secret: Secret
    
    var body: some View {
        List {
            if secret.payload.isEmpty {
                Text("Empty secret")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .listRowBackground(Color.clear)
            } else {
                Text(.init(secret.payload))
                    .font(.callout)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                    .privacySensitive()
                    .listRowBackground(Color.clear)
            }
            
            if !secret.tags.isEmpty {
                Tagger(secret: secret)
                    .privacySensitive()
                    .listRowBackground(Color.clear)
            }
            
            Text(verbatim: secret.date.formatted(.relative(presentation: .named, unitsStyle: .wide)))
                .foregroundColor(.secondary)
                .font(.caption2)
                .listRowBackground(Color.clear)
            
            NavigationLink {
                Edit(name: secret.name, payload: secret.payload, secret: secret)
            } label: {
                Label("Edit", systemImage: "pencil.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .font(.caption2)
                    .foregroundColor(.accentColor)
            }
            .listRowBackground(Color.clear)
        }
        .navigationTitle(secret.name)
    }
}
