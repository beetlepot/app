import SwiftUI
import UserNotifications
import Secrets

struct Sidebar: View {
    @State private var filter =  Filter()
    @State private var filtered = [Secret]()
    
    var body: some View {
        NavigationView {
            Items(filtered: $filtered)
                .searchable(text: $filter.search)
        }
        .onReceive(cloud.archive) {
            filtered = $0.filtering(with: filter)
        }
        .onChange(of: filter) { filter in
            Task {
                filtered = await cloud._archive.filtering(with: filter)
            }
        }
        .task {
            if await UNUserNotificationCenter.authorization == .notDetermined {
                await UNUserNotificationCenter.request()
            }
        }
    }
}
