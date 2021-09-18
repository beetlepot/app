import SwiftUI
import Secrets

struct Validate: View {
    @State private var loading = true
    @State private var secret: Secret?
    
    var body: some View {
        NavigationView {
            if loading {
                Image(systemName: "hourglass")
                    .resizable()
                    .font(.largeTitle.weight(.light))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
                    .symbolVariant(.circle)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color("Spot"), Color.accentColor)
                    .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
            } else if let secret = secret {
                Create(secret: secret)
            } else {
                Full()
            }
        }
        .navigationViewStyle(.stack)
        .task {
            do {
                let id = try await cloud.secret()
                secret = await cloud.model[id]
                await UNUserNotificationCenter.send(message: "Created a new secret!")
            } catch { }
            loading = false
        }
    }
}
