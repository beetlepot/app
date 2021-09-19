import SwiftUI
import Secrets

extension Reveal {
    struct Content: View {
        @Binding var secret: Secret
        @State private var tags = false
        
        var body: some View {
            ScrollView {
                VStack(spacing: 15) {
                    if !secret.tags.isEmpty {
                        Tagger(tags: secret.tags.list)
                            .privacySensitive()
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
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
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
                            .font(.title3)
                        Text("Tags")
                            .font(.footnote)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: Writer(id: secret.id).equatable()) {
                        Image(systemName: "pencil.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title)
                    }
                    
                    Spacer()
                    
                    Button {
                        UIPasteboard.general.string = secret.payload
                        Task {
                            await UNUserNotificationCenter.send(message: "Secret copied!")
                        }
                    } label: {
                        Text("Copy")
                        Image(systemName: "doc.on.doc.fill")
                            .symbolRenderingMode(.hierarchical)
                    }
                    .font(.footnote)
                    
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
