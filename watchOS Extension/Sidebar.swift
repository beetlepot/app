import SwiftUI
import UserNotifications
import Secrets

struct Sidebar: View {
    let archive: Archive
    @State private var filter =  Filter()
    @State private var filtered = [Int]()
    
    var body: some View {
        NavigationView {
            Items(archive: archive, filtered: $filtered)
                .searchable(text: $filter.search)
        }
        .onAppear {
            filtered = archive.filtering(with: filter)
        }
        .onChange(of: archive) {
            filtered = $0.filtering(with: filter)
        }
        .onChange(of: filter) {
            filtered = archive.filtering(with: $0)
        }
        .task {
            if await UNUserNotificationCenter.authorization == .notDetermined {
                await UNUserNotificationCenter.request()
            }
        }
    }
}
