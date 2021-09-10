import SwiftUI
import Archivable
import Secrets

let cloud = Cloud.new
let store = Store()

@main struct App: SwiftUI.App {
    @State private var archive = Archive.new
    @Environment(\.scenePhase) private var phase
    @WKExtensionDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            Sidebar(archive: archive)
                .onReceive(cloud.archive) {
                    archive = $0
                }
        }
        .onChange(of: phase) {
            if $0 == .active {
                cloud.pull.send()
            }
        }
    }
}
