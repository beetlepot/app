import SwiftUI
import Secrets

struct Create: View {    
    @State var secret: Secret
    @State private var index = 0
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        TabView(selection: $index) {
            First(secret: $secret, reindex: reindex)
                .equatable()
                .tag(0)
            Second(secret: $secret, reindex: reindex)
                .tag(1)
            Third(secret: $secret, reindex: reindex)
                .equatable()
                .tag(2)
        }
        .tabViewStyle(.page)
        .symbolRenderingMode(.hierarchical)
        .navigationTitle("New Secret")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .font(.callout)
            }
        }
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .init(named: "AccentColor")
            UIPageControl.appearance().pageIndicatorTintColor = .quaternaryLabel
        }
        .onReceive(cloud) {
            secret = $0[secret.id]
        }
    }
    
    private func reindex(_ to: Int) {
        withAnimation(.easeInOut(duration: 0.35)) {
            index = to
        }
    }
}
