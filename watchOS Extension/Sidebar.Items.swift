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
            List {
                HStack {
                    Text(capacity, format: .number)
                        .foregroundColor(.init("Spot"))
                        .font(.title2.bold())
                    + Text(capacity == 1 ? "\nSpot" : "\nSpots")
                        .font(.caption2)
                    Spacer()
                    Text(count, format: .number)
                        .foregroundColor(.accentColor)
                        .font(.title2.bold())
                    + Text(count == 1 ? "\nSecret" : "\nSecrets")
                        .font(.caption2)
                }
                .multilineTextAlignment(.center)
                .listRowBackground(Color.clear)
                
                Spacer()
                    .listRowBackground(Color.clear)
                
                ForEach(filtered) {
                    Item(selected: $selected, secret: $0)
                }
                
                if !filtered.isEmpty {
                    Spacer()
                        .listRowBackground(Color.clear)
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
                    .listRowBackground(Color.clear)
                } else {
                    Text("You reached the limit of secrets that you can keep. Purchase spots to add more secrets.")
                        .font(.caption2)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundStyle(.secondary)
                        .listRowBackground(Color.clear)
                }
                
                Spacer()
                    .listRowBackground(Color.clear)
                
                NavigationLink(tag: -1, selection: $selected) {
                    Purchases()
                } label: {
                    ZStack {
                        Capsule()
                            .fill(Color.accentColor)
                        HStack {
                            Spacer()
                            Label("Purchases", systemImage: "cart")
                                .symbolRenderingMode(.hierarchical)
                                .font(.footnote)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                    }
                    .padding(.horizontal)
                }
                .listRowBackground(Color.clear)
            }
            .onReceive(cloud) {
                available = $0.available
                capacity = $0.capacity
                count = $0.count
            }
        }
    }
}
