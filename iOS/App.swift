import SwiftUI
import LocalAuthentication
import Archivable
import Secrets

let cloud: Cloud<Archive> = .new
let store = Store()

@main struct App: SwiftUI.App {
    @State private var archive = Archive.new
    @State private var authenticated = false
    @AppStorage(Defaults._authenticate.rawValue) private var authenticate = false
    @Environment(\.scenePhase) private var phase
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Sidebar(archive: archive)
                Empty(empty: archive.count == 0)
            }
            .navigationViewStyle(.columns)
            .onReceive(cloud.archive) {
                archive = $0
            }
        }
        .onChange(of: phase) {
            switch $0 {
            case .active:
                if authenticate && !authenticated {
                    auth()
                } else {
                    authenticated = true
                }
                cloud.pull.send()
            case .background:
                if authenticate {
                    authenticated = false
                }
            default:
                break
            }
        }
    }
    
    private func auth() {
        let context = LAContext()
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) else {
            authenticated = true
            return
        }

        context
            .evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Authenticate to access your secrets") {
                guard $0, $1 == nil else { return }
                DispatchQueue
                    .main
                    .async {
                        authenticated = true
                    }
            }
    }
}
