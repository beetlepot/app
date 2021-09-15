import SwiftUI
import Archivable
import Secrets

let cloud = Cloud<Archive>.new
let store = Store()

@main struct App: SwiftUI.App {
    @Environment(\.scenePhase) private var phase
    @WKExtensionDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            Sidebar()
        }
        .onChange(of: phase) {
            if $0 == .active {
                cloud.pull.send()
            }
        }
    }
}
