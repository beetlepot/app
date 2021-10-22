import SwiftUI

struct Middlebar: View {
    var body: some View {
        List {
            app
            help
        }
        .listStyle(.insetGrouped)
        .symbolRenderingMode(.hierarchical)
        .navigationTitle("Menu")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private var app: some View {
        Section("App") {
            NavigationLink(destination: Settings()) {
                Label("Settings", systemImage: "slider.horizontal.3")
            }
            
            NavigationLink(destination: Capacity()) {
                Label("Capacity", systemImage: "lock.square.stack")
            }
            
            NavigationLink(destination: About()) {
                Label("About", systemImage: "ladybug")
            }
        }
        .font(.callout)
        .headerProminence(.increased)
    }
    
    private var help: some View {
        Section("Help") {
            NavigationLink(destination: Info(title: "Markdown", text: Copy.markdown)) {
                Label("Markdown", systemImage: "square.text.square")
            }
            
            NavigationLink(destination: Info(title: "Privacy policy", text: Copy.privacy)) {
                Label("Privacy policy", systemImage: "hand.raised")
            }
            
            NavigationLink(destination: Info(title: "Terms and conditions", text: Copy.terms)) {
                Label("Terms and conditions", systemImage: "doc.plaintext")
            }
        }
        .font(.callout)
        .headerProminence(.increased)
    }
}
