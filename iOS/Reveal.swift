import SwiftUI
import Secrets

struct Reveal: View {
    @State var secret: Secret
    @State private var deleted = false
    
    var body: some View {
        if deleted {
            Empty()
        } else {
            Content(secret: $secret)
                .onReceive(cloud) {
                    if $0[secret.id] == .new {
                        deleted = true
                    } else {
                        secret = $0[secret.id]
                    }
                }
        }
    }
}
