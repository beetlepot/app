import SwiftUI
import Secrets

extension Sidebar {
    struct Items: View {
        let filtered: [Secret]
        @State private var selected: Int?
        @State private var available = false
        @State private var capacity = 0
        @State private var count = 0
        
        var body: some View {
            ScrollView {
                HStack {
                    Text(capacity, format: .number)
                        .foregroundColor(.init("Spot"))
                        .font(.title3.bold())
                    + Text(capacity == 1 ? "\nSpot" : "\nSpots")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(count, format: .number)
                        .foregroundColor(.accentColor)
                        .font(.title3.bold())
                    + Text(count == 1 ? "\nSecret" : "\nSecrets")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .multilineTextAlignment(.center)
                .padding(.bottom)
                
                ForEach(filtered) {
                    Item(selected: $selected, secret: $0)
                }
                
                if available {
                    Button {
                        Task {
                            do {
                                selected = try await cloud.secret()
                            } catch {
                                
                            }
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle)
                            .symbolRenderingMode(.hierarchical)
                            .frame(maxWidth: .greatestFiniteMagnitude)
                            .foregroundColor(.init("Spot"))
                    }
                    .buttonStyle(.plain)
                    .padding(.vertical)
                } else {
                    Text("You reached the limit of secrets that you can keep. Purchase spots to add more secrets.")
                        .font(.caption2)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundStyle(.secondary)
                        .padding()
                }
                
                NavigationLink(tag: -1, selection: $selected) {
                    Purchases()
                } label: {
                    ZStack {
                        Capsule()
                            .fill(Color.accentColor)
                        Label("Purchases", systemImage: "cart")
                            .symbolRenderingMode(.hierarchical)
                            .font(.footnote)
                            .foregroundColor(.white)
                            .padding(.vertical)
                    }
                }
                .buttonStyle(.plain)
                .padding()
            }
            .onReceive(cloud) {
                available = $0.available
                capacity = $0.capacity
                count = $0.count
            }
        }
    }
}
