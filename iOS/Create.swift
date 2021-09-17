import SwiftUI
import Secrets

struct Create: View {
    let id: Int
    @State private var secret = Secret.new
    @State private var index = 0
    @State private var name = ""
    @State private var payload = false
    @State private var tags = false
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
        }
        .navigationViewStyle(.stack)
        .onReceive(cloud) {
            secret = $0[id]
            name = secret.name
        }
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .init(named: "AccentColor")
            UIPageControl.appearance().pageIndicatorTintColor = .quaternaryLabel
        }
    }
    
    private var card0: some View {
        VStack {
            HStack {
                Image(systemName: "lock.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.accentColor)
                Text("Enter your secret")
                Spacer()
            }
            .padding()
            
            Text(verbatim: secret.payload.isEmpty ? "This secret is empty" : secret.payload)
                .privacySensitive()
                .foregroundColor(secret.payload.isEmpty ? .secondary : .accentColor)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .padding()
            
            Button {
                payload = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .buttonStyle(.bordered)
            .padding(.bottom)
            .sheet(isPresented: $payload) {
                NavigationView {
                    Writer(id: id) {
                        payload = false
                    }
                }
                .navigationViewStyle(.stack)
            }
            
            Spacer()
            
            Button {
                reindex(to: 1)
            } label: {
                Image(systemName: "arrow.right")
            }
            .padding(.bottom, 80)
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
        .tag(0)
    }
    
    private var card1: some View {
        VStack {
            HStack {
                Image(systemName: "character.textbox")
                    .font(.largeTitle)
                    .foregroundColor(.accentColor)
                Text("Identify it with a name")
                Spacer()
            }
            .padding()
            
            TextField(name, text: $name)
                .focused($focus)
                .textInputAutocapitalization(.sentences)
                .disableAutocorrection(!Defaults.correction)
                .submitLabel(.done)
                .foregroundColor(.accentColor)
                .privacySensitive()
                .padding()
                .onChange(of: focus) {
                    if $0 == false {
                        Task {
                            await cloud.update(id: id, name: name)
                        }
                    }
                }
            
            Button {
                focus.toggle()
            } label: {
                Label("Name", systemImage: "pencil")
            }
            .buttonStyle(.bordered)
            .padding(.bottom)
            
            Spacer()
            
            HStack(spacing: 40) {
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
            .padding(.bottom, 80)
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
        .tag(1)
    }
    
    private var card2: some View {
        VStack {
            HStack {
                Image(systemName: "tag.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.accentColor)
                Text("Personalise with tags")
                Spacer()
            }
            .padding()
            
            if secret.tags.isEmpty {
                Text("No tags added")
                    .foregroundStyle(.tertiary)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .padding()
            } else {
                Tagger(tags: secret.tags.list)
                    .privacySensitive()
                    .padding()
            }
            
            Button {
                tags = true
            } label: {
                Label("Tags", systemImage: "tag")
            }
            .sheet(isPresented: $tags) {
                Tags(secret: secret)
                    .edgesIgnoringSafeArea(.all)
            }
            .buttonStyle(.bordered)
            .padding(.bottom)
            
            Spacer()
            
            Button {
                reindex(to: 1)
            } label: {
                Image(systemName: "arrow.left")
            }
            .padding(.bottom, 80)
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
        .tag(2)
    }
    
    private func reindex(to: Int) {
        withAnimation(.easeInOut(duration: 0.35)) {
            index = to
        }
    }
}
