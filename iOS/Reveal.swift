import SwiftUI
import Secrets

struct Reveal: View {
    let secret: Secret
    @State private var first = true
    @State private var editing = false
    @State private var deleted = false
    @State private var tags = false
    
    var body: some View {
        if deleted {
            Empty(empty: false)
        } else if editing {
            Writer(secret: secret, editing: $editing)
        } else {
            ScrollView {
                VStack {
                    if secret.payload.isEmpty {
                        Text("Empty secret")
                            .font(.callout)
                            .foregroundStyle(.tertiary)
                            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    } else {
                        Text(.init(secret.payload))
                            .kerning(1)
                            .font(.title3.weight(.regular))
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                            .textSelection(.enabled)
                            .privacySensitive()
                    }
                    
                    if !secret.tags.isEmpty {
                        Tagger(tags: secret.tags.list)
                            .privacySensitive()
                    }
                    
                    Text(verbatim: secret.date.formatted(.relative(presentation: .named, unitsStyle: .wide)))
                        .font(.footnote)
                        .foregroundStyle(.tertiary)
                        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
                        .padding(.top, 5)
                }
                .padding(UIDevice.pad ? 80 : 30)
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        tags = true
                    } label: {
                        Image(systemName: "tag.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title2)
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            editing = true
                        }
                    } label: {
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
                        Label("Copy", systemImage: "doc.on.doc.fill")
                            .symbolRenderingMode(.hierarchical)
                    }
                    .buttonStyle(.bordered)
                    .font(.footnote)
                }
            }
            .onChange(of: secret) {
                if $0 == .new {
                    deleted = true
                }
            }
            .sheet(isPresented: $tags) {
                Tags(tags: secret.tags) { tag in
                    Task {
                        if secret.tags.contains(tag) {
                            await cloud.remove(id: secret.id, tag: tag)
                        } else {
                            await cloud.add(id: secret.id, tag: tag)
                        }
                    }
                }
            }
            .navigationTitle(secret.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
