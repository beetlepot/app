import SwiftUI

struct Capacity: View {
    @State private var count = 0
    @State private var capacity = 0
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
                        .font(.title3.monospacedDigit())
                        .animation(.none, value: percentage)
                    Text("Used")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                }
            }
            .frame(maxWidth: 180, maxHeight: 180)
            
            HStack(spacing: 40) {
                Text(capacity, format: .number)
                    .foregroundColor(.init("Spot"))
                    .font(.title.bold())
                + Text(capacity == 1 ? "\nSpot" : "\nSpots")
                    .font(.footnote)
                
                Text(count, format: .number)
                    .foregroundColor(.accentColor)
                    .font(.title.bold())
                + Text(count == 1 ? "\nSecret" : "\nSecrets")
                    .font(.footnote)
            }
            .padding(.top)
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
        Task {
            count = await cloud._archive.count
            capacity = await cloud._archive.capacity
            
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 1.2)) {
                    percentage = .init(count) / .init(capacity)
                }
            }
        }
    }
}
