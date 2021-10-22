import SwiftUI
import Secrets

extension Create {
    struct Third: View, Equatable {
        @Binding var secret: Secret
        let reindex: (Int) -> Void
        @State private var tags = false
        
        var body: some View {
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
                        .onTapGesture {
                            tags = true
                        }
                } else {
                    Tagger(tags: secret.tags.list)
                        .privacySensitive()
                        .padding()
                        .onTapGesture {
                            tags = true
                        }
                }
                
                Button {
                    tags = true
                } label: {
                    Label("Tags", systemImage: "tag")
                }
                .sheet(isPresented: $tags) {
                    Tags(secret: secret)
                        .ignoresSafeArea(edges: .all)
                }
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
                
                Spacer()
                
                Button {
                    reindex(1)
                } label: {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.largeTitle)
                }
                .padding(.bottom, 80)
            }
            .frame(maxWidth: .greatestFiniteMagnitude)
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            true
        }
    }
}
