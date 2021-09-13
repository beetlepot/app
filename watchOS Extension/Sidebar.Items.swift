import SwiftUI
import Secrets

extension Sidebar {
    struct Items: View {
        let archive: Archive
        @Binding var filtered: [Int]
        @State private var selected: Int?
        
        var body: some View {
            List {
                HStack {
                    Text(archive.capacity, format: .number)
                        .foregroundColor(.init("Spot"))
                        .font(.title3.bold())
                    + Text(archive.capacity == 1 ? "\nSpot" : "\nSpots")
                        .font(.caption2)
                    Spacer()
                    Text(archive.count, format: .number)
                        .foregroundColor(.accentColor)
                        .font(.title3.bold())
                    + Text(archive.count == 1 ? "\nSecret" : "\nSecrets")
                        .font(.caption2)
                }
                .multilineTextAlignment(.center)
                .padding(.vertical)
                .listRowBackground(Color.clear)
                
                ForEach(filtered, id: \.self) {
                    Item(selected: $selected, secret: archive[$0])
                }
                
                if archive.available {
                    Button {
                        Task {
                            selected = await cloud.secret()
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle)
                            .symbolRenderingMode(.hierarchical)
                            .frame(maxWidth: .greatestFiniteMagnitude)
                            .foregroundColor(.accentColor)
                    }
                    .padding(.vertical)
                    .listRowBackground(Color.clear)
                } else {
                    Text("You reached the limit of secrets that you can keep. Purchase spots to add more secrets.")
                        .font(.caption2)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundStyle(.secondary)
                        .listRowBackground(Color.clear)
                        .padding(.vertical)
                }
                
                NavigationLink(tag: -1, selection: $selected) {
                    Purchases()
                } label: {
                    Label("In-App Purchases", systemImage: "cart")
                        .symbolRenderingMode(.hierarchical)
                        .font(.caption2)
                        .foregroundColor(.accentColor)
                }
                .listRowBackground(Color.clear)
            }
        }
    }
}
