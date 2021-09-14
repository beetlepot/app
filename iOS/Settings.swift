import SwiftUI
import Secrets

struct Settings: View {
    @State private var requested = true
    @State private var enabled = true
    @Environment(\.dismiss) private var dismiss
    @AppStorage(Defaults._authenticate.rawValue) private var authenticate = false
    @AppStorage(Defaults._tools.rawValue) private var tools = true
    @AppStorage(Defaults._spell.rawValue) private var spell = true
    @AppStorage(Defaults._correction.rawValue) private var correction = false
    
    var body: some View {
        List {
            if !requested || !enabled {
                notifications
            }
            
            security
            edit
        }
        .symbolRenderingMode(.multicolor)
        .toggleStyle(SwitchToggleStyle(tint: .orange))
        .listStyle(.grouped)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await check()
        }
    }
    
    private func check() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        if settings.authorizationStatus == .notDetermined {
            requested = false
        } else if settings.alertSetting == .disabled {
            enabled = false
        }
    }
    
    private var notifications: some View {
        Section("Notifications") {
            Text(Copy.notifications)
                .font(.callout)
                .padding(.bottom)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            Button {
                if requested {
                    dismiss()
                    UIApplication.shared.settings()
                } else {
                    Task {
                        _ = await UNUserNotificationCenter.request()
                        requested = true
                        await check()
                    }
                }
            } label: {
                HStack {
                    Text("Activate notifications")
                        .font(.callout)
                    Spacer()
                    Image(systemName: "app.badge")
                        .font(.title3)
                }
            }
        }
    }
    
    private var security: some View {
        Section("Security") {
            Toggle(isOn: $authenticate) {
                Label("Secure with Face ID", systemImage: "faceid")
            }
        }
    }
    
    private var edit: some View {
        Section("Edit") {
            Toggle(isOn: $tools) {
                Label("Show toolbar above keyboard", systemImage: "hammer")
            }
            
            Toggle(isOn: $spell) {
                Label("Spell checking", systemImage: "text.book.closed")
            }
            
            Toggle(isOn: $correction) {
                Label("Auto correction", systemImage: "ant")
            }
        }
    }
}
