import SwiftUI
import Secrets

struct Reveal: View {
    @State var secret: Secret
    @State private var deleted = false
    @State private var tags = false
    
    var body: some View {
        if deleted {
            Empty()
        } else {
            ScrollView {
                VStack {
                    if !secret.tags.isEmpty {
                        Tagger(tags: secret.tags.list)
                            .privacySensitive()
                            .padding(.bottom)
                    }
                    
                    if secret.payload.isEmpty {
                        Text("Empty secret")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    } else {
                        Text(.init(secret.payload))
                            .kerning(1)
                            .font(.title3.weight(.regular))
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                            .textSelection(.enabled)
                            .privacySensitive()
                    }
                    
                    Text("Updated " + secret.date.formatted(.relative(presentation: .named, unitsStyle: .wide)))
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
                }
                .padding()
            }
            .navigationTitle(secret.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        tags = true
                    } label: {
                        Image(systemName: "tag.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title2)
                        Text("Tags")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: Writer(id: secret.id)) {
                        Image(systemName: "pencil.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title2)
                    }
                    
                    Spacer()
                    
                    Button {
                        UIPasteboard.general.string = secret.payload
                        Task {
                            await UNUserNotificationCenter.send(message: "Secret copied!")
                        }
                    } label: {
                        Text("Copy")
                            .font(.caption)
                        Image(systemName: "doc.on.doc.fill")
                            .font(.callout)
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                }
            }
            .onReceive(cloud) {
                if $0[secret.id] == .new {
                    deleted = true
                } else {
                    secret = $0[secret.id]
                }
            }
            .sheet(isPresented: $tags) {
                Tags(secret: secret)
                    .edgesIgnoringSafeArea(.all)
            }
            .task {
                if let created = Defaults.created {
                    let days = Calendar.current.dateComponents([.day], from: created, to: .init()).day!
                    if !Defaults.rated && days > 6 {
                        UIApplication.shared.review()
                        Defaults.rated = true
                    }
                } else {
                    Defaults.created = .init()
                }
            }
        }
    }
}
