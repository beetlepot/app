import SwiftUI

struct Tagger: View {
    let tags: [String]
    @State private var height = CGFloat(32)
    private let color = GraphicsContext.Shading.color(.init("Spot"))
    
    var body: some View {
        Canvas { context, size in
            var x = CGFloat()
            var y = CGFloat()
            var last = CGFloat()
            
            for tag in tags {
                let text = Text(verbatim: tag)
                    .foregroundColor(.white)
                    .font(.footnote.weight(.medium))
                    
                let resolved = context.resolve(text)
                let textSize = resolved.measure(in: .init(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude))
                let capsuleSize = CGSize(width: ceil(textSize.width) + 24, height: ceil(textSize.height) + 8)
                
                if x + capsuleSize.width > size.width {
                    x = 0
                    y += 6 + last
                    last = 0
                }
                
                last = max(last, capsuleSize.height)
                
                context.fill(Capsule()
                                .path(in: .init(origin: .init(x: x, y: y), size: capsuleSize)),
                             with: color)
                
                context.draw(resolved, at: .init(x: x + 12, y: y + 4), anchor: .topLeading)
                
                x += 6 + capsuleSize.width
            }
            
            Task { [y, last] in
                height = y + last
            }
        }
        .accessibilityLabel("Tags")
        .accessibilityChildren {
            List(tags, id: \.self) {
                Text(verbatim: $0)
            }
        }
        .frame(height: height)
    }
}
