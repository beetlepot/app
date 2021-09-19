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
                        .font(.title.monospacedDigit())
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
                    .font(.largeTitle.bold())
                + Text(capacity == 1 ? "\nSpot" : "\nSpots")
                    .font(.footnote)
                
                Text(count, format: .number)
                    .foregroundColor(.accentColor)
                    .font(.largeTitle.bold())
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
            .sheet(isPresented: $purchases, onDismiss: {
                Task {
                    await update()
                }
            }, content: Purchases.init)
            
            Spacer()
            
            Text(Copy.capacity)
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .frame(maxWidth: 500)
        }
        .navigationTitle("Capacity")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await update()
        }
    }
    
    private func update() async {
        let count = await cloud.model.count
        let capacity = await cloud.model.capacity
        self.count = count
        self.capacity = capacity
        
        withAnimation(.easeInOut(duration: 1.2)) {
            percentage = .init(count) / max(.init(capacity), 1)
        }
    }
}
