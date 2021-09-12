import SwiftUI
import UserNotifications
import Secrets

struct Sidebar: View {
    let archive: Archive
    @State private var search =  ""
    @State private var selected: Int?
    @State private var filtered = [Int]()
    
    var body: some View {
        NavigationView {
            List {
                if search.isEmpty {
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
                }
                
                if !filtered.isEmpty && archive.count > 0 {
                    ForEach(filtered, id: \.self) {
                        Item(selected: $selected, secret: archive[$0])
                    }
                }
                
                if search.isEmpty {
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
            .searchable(text: $search)
        }
        .onChange(of: archive) {
            filtered = $0.filter(favourites: false, search: search)
        }
        .onChange(of: search) {
            filtered = archive.filter(favourites: false, search: $0)
        }
        .onAppear {
            Task {
                if await UNUserNotificationCenter.authorization == .notDetermined {
                    await UNUserNotificationCenter.request()
                }
            }
        }
    }
}
