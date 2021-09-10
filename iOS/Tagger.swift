import SwiftUI
import Secrets

struct Tagger: View {
    let secret: Secret
    let tags: Int
    
    var body: some View {
        VStack {
            ForEach(secret
                        .tags
                        .sorted()
                        .reduce(into: [[Tag]]()) {
                if $0.isEmpty || $0.last!.count == tags {
                    $0.append([$1])
                } else {
                    $0[$0.count - 1].append($1)
                }
            }, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { tag in
                        ZStack {
                            Capsule()
                                .fill(Color.orange)
                            Text(verbatim: "\(tag)")
                                .font(.footnote)
                                .foregroundColor(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                        }
                        .fixedSize()
                    }
                    Spacer()
                }
            }
        }
    }
}
