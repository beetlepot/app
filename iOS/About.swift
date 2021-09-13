import SwiftUI
import Secrets

struct About: View {
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    VStack {
                        Image("Logo")
                        Group {
                            Text(verbatim: "Beetle\n")
                            + Text(verbatim: Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "")
                                .foregroundColor(.init("Spot"))
                        }
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.body)
                        .foregroundStyle(.primary)
                    }
                    .padding(.vertical, 70)
                    Spacer()
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            
            Section {
                Link(destination: URL(string: "https://beetlepot.github.io/about/")!) {
                    Label("Beetle", systemImage: "link")
                }
                
                Button {
                    UIApplication.shared.review()
                    Defaults.rated = true
                } label: {
                    Label("Rate on the App Store", systemImage: "star")
                }
            }
            .font(.callout)
            
            Section {
                HStack(spacing: 0) {
                    Spacer()
                    Text("From Berlin with ")
                    Image(systemName: "heart")
                    Spacer()
                }
            }
            .font(.caption)
            .foregroundColor(.secondary)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .symbolRenderingMode(.multicolor)
        .toggleStyle(SwitchToggleStyle(tint: .orange))
        .listStyle(.insetGrouped)
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.large)
    }
}