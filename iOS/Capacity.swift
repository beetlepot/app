import SwiftUI
import Secrets

struct Capacity: View {
    let archive: Archive
    @State private var percentage = Double()
    @State private var purchases = false
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                Ring(amount: 1)
                    .stroke(Color(.quaternarySystemFill), lineWidth: 9)
                Ring(amount: percentage)
                    .stroke(LinearGradient(
                                gradient: .init(colors: [.init("Spot"), .accentColor]),
                                startPoint: .top,
                                endPoint: .bottom),
                            style: .init(lineWidth: 9,
                                         lineCap: .round))
                VStack {
                    Text(Int(percentage * 100), format: .percent)
                        .font(.body.monospacedDigit())
                        .font(Font.largeTitle.monospacedDigit().weight(.light))
                        .animation(.none, value: percentage)
                    Text("Used")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                }
            }
            .frame(maxWidth: 180, maxHeight: 180)
            
            HStack(spacing: 35) {
                Text(archive.capacity, format: .number)
                    .foregroundColor(.init("Spot"))
                    .font(.title2.bold())
                + Text(archive.capacity == 1 ? "\nSpot" : "\nSpots")
                    .font(.footnote)
                
                Text(archive.count, format: .number)
                    .foregroundColor(.accentColor)
                    .font(.title2.bold())
                + Text(archive.count == 1 ? "\nSecret" : "\nSecrets")
                    .font(.footnote)
            }
            .multilineTextAlignment(.center)
            
            Spacer()
            
            Button {
                purchases = true
            } label: {
                Text("In-App Purchases")
            }
            .buttonStyle(.bordered)
            .sheet(isPresented: $purchases, onDismiss: update, content: Purchases.init)
            
            Spacer()
            
            Text("Your secrets capacity is permanent and won't expire, you can create and delete secrets as many times as you want.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .frame(maxWidth: 500)
        }
        .navigationTitle("Capacity")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: update)
    }
    
    private func update() {
        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 1.2)) {
                percentage = .init(archive.count) / .init(archive.capacity)
            }
        }
    }
}
