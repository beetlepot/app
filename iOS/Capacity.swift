import SwiftUI
import Secrets

struct Capacity: View {
    let archive: Archive
    @State private var state = Store.Status.loading
    
    var body: some View {
        VStack(spacing: 0) {
            Content(state: state)
            Text("Your secrets capacity is permanent and won't expire, you can create and delete secrets as many times as you want.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .frame(maxWidth: 500)
        }
        .navigationTitle("Capacity")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text(verbatim: "\(archive.count) / \(archive.capacity) " + (archive.capacity == 1 ? "secret" : "secrets"))
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
        }
        .onReceive(store.status) {
            state = $0
        }
        .task {
            await store.load()
        }
    }
}
