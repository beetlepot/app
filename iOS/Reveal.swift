import SwiftUI
import Secrets

struct Reveal: View {
    let secret: Secret
    @State private var first = true
    @State private var editing = false
    @State private var tags = false
    
    var body: some View {
        if editing {
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
                        Tagger(secret: secret)
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
                    
                    Button(action: edit) {
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
            .sheet(isPresented: $tags) {
                Tags(secret: secret)
            }
            .task {
                if secret.payload.isEmpty && secret.name == "Untitled" && secret.tags.isEmpty && secret.date.timeIntervalSince(.now) > -2 {
                    edit()
                }
            }
            .navigationTitle(secret.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func edit() {
        withAnimation(.easeInOut(duration: 0.4)) {
            editing = true
        }
    }
}
