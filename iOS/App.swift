import SwiftUI
import LocalAuthentication
import Secrets

@main struct App: SwiftUI.App {
    @State private var authenticated = false
    @Environment(\.scenePhase) private var phase
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Sidebar()
                Empty()
            }
            .navigationViewStyle(.columns)
            .onReceive(delegate.store, perform: store.purchase)
        }
        .onChange(of: phase) {
            switch $0 {
            case .active:
                if Defaults.authenticate && !authenticated {
                    auth()
                } else {
                    authenticated = true
                }
                cloud.pull.send()
            case .background:
                if Defaults.authenticate {
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
