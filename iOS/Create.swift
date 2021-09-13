import SwiftUI
import Secrets

private let width = CGFloat(200)

struct Create: View {
    let secret: Secret
    @State private var index = 0
    @State private var edit = false
    @State private var tags = false
    @State private var name = ""
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focus: Bool
    
    var body: some View {
        NavigationView {
            TabView(selection: $index) {
                card0
                card1
                card2
            }
            .tabViewStyle(.page)
            .navigationTitle(secret.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("New secret")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.callout)
                }
            }
        }
        .navigationViewStyle(.stack)
        .onAppear {
            name = secret.name
            UIPageControl.appearance().currentPageIndicatorTintColor = .init(named: "AccentColor")
            UIPageControl.appearance().pageIndicatorTintColor = .quaternaryLabel
        }
    }
    
    private var card0: some View {
        VStack {
            Spacer()
            
            Image(systemName: "ladybug.fill")
                .font(.title)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.accentColor)
            
            Text("What is the content\nof this secret?")
                .padding(.top)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: width, alignment: .leading)
            
            Text(verbatim: secret.payload)
                .privacySensitive()
                .foregroundColor(.secondary)
                .lineLimit(1)
                .padding(.vertical)
                .frame(width: width, alignment: .leading)
            
            Button {
                edit = true
            } label: {
                Label("Content", systemImage: "pencil.circle.fill")
                    .symbolRenderingMode(.hierarchical)
            }
            .sheet(isPresented: $edit) {
                NavigationView {
                    Writer(secret: secret, editing: $edit)
                }
                .navigationViewStyle(.stack)
            }
            
            Spacer()
            
            Button {
                reindex(to: 1)
            } label: {
                Image(systemName: "arrow.right")
            }
            .padding(.bottom, 70)
        }
        .tag(0)
    }
    
    private var card1: some View {
        VStack {
            Spacer()
            
            Image(systemName: "ladybug.fill")
                .font(.title)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.accentColor)
            
            Text("Identify this secret\nwith a name")
                .padding(.top)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: width, alignment: .leading)
            
            TextField(secret.name, text: $name)
                .focused($focus)
                .submitLabel(.done)
                .foregroundColor(.accentColor)
                .privacySensitive()
                .padding()
                .frame(width: width)
                .onSubmit {
                    Task {
                        await cloud.update(id: secret.id, name: name)
                    }
                }
            
            Button {
                focus = true
            } label: {
                Label("Name", systemImage: "pencil.circle.fill")
                    .symbolRenderingMode(.hierarchical)
            }
            
            Spacer()
            
            HStack {
                Button {
                    reindex(to: 0)
                } label: {
                    Image(systemName: "arrow.left")
                }
                Button {
                    reindex(to: 2)
                } label: {
                    Image(systemName: "arrow.right")
                }
            }
            .padding(.bottom, 70)
        }
        .tag(1)
    }
    
    private var card2: some View {
        VStack {
            Spacer()
            
            Image(systemName: "ladybug.fill")
                .font(.title)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.accentColor)
            
            Text("Personalise your secret\nwith tags")
                .padding(.top)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: width, alignment: .leading)
            
            Tagger(tags: secret.tags.list)
                .privacySensitive()
                .padding(.vertical)
                .frame(width: width)
            
            Button {
                tags = true
            } label: {
                Label("Tags", systemImage: "tag.circle.fill")
                    .symbolRenderingMode(.hierarchical)
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
            
            Spacer()
            
            Button {
                reindex(to: 1)
            } label: {
                Image(systemName: "arrow.left")
            }
            .padding(.bottom, 70)
        }
        .tag(2)
    }
    
    private func reindex(to: Int) {
        withAnimation(.easeInOut(duration: 0.3)) {
            index = to
        }
    }
}
