import SwiftUI
import Secrets

private let width = CGFloat(200)

struct Create: View {
    let id: Int
    @State private var index = 0
    @State private var name = ""
    @State private var payload = ""
    @State private var tags = Set<Tag>()
    @State private var editPayload = false
    @State private var editTags = false
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
            .navigationTitle(name)
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
        .onReceive(cloud.archive) {
            name = $0[id].name
            payload = $0[id].payload
            tags = $0[id].tags
        }
        .onAppear {
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
            
            Text(verbatim: payload)
                .privacySensitive()
                .foregroundColor(.secondary)
                .lineLimit(1)
                .padding(.vertical)
                .frame(width: width, alignment: .leading)
            
            Button {
                editPayload = true
            } label: {
                Label("Content", systemImage: "pencil.circle.fill")
                    .symbolRenderingMode(.hierarchical)
            }
            .sheet(isPresented: $editPayload) {
                NavigationView {
                    Writer(id: id, editing: $editPayload)
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
            
            TextField(name, text: $name)
                .focused($focus)
                .textInputAutocapitalization(.sentences)
                .disableAutocorrection(!Defaults.correction)
                .submitLabel(.done)
                .foregroundColor(.accentColor)
                .privacySensitive()
                .padding()
                .frame(width: width)
                .onChange(of: focus) {
                    if $0 == false {
                        Task {
                            await cloud.update(id: id, name: name)
                        }
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
                .padding(.bottom)
            
            if !tags.isEmpty {
                Tagger(tags: tags.list)
                    .privacySensitive()
                    .padding(.bottom)
                    .frame(width: width)
            }
            
            Button {
                editTags = true
            } label: {
                Label("Tags", systemImage: "tag.circle.fill")
                    .symbolRenderingMode(.hierarchical)
            }
            .sheet(isPresented: $editTags) {
                Tags(tags: tags) { tag in
                    Task {
                        if tags.contains(tag) {
                            await cloud.remove(id: id, tag: tag)
                        } else {
                            await cloud.add(id: id, tag: tag)
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
