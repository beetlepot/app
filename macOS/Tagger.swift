import AppKit
import Combine

final class Tagger: NSView {
    override var frame: NSRect {
        didSet {
            width.send(frame.size.width)
        }
    }
    
    override var isFlipped: Bool {
        true
    }
    
    let tags = PassthroughSubject<[String], Never>()
    private var sub: AnyCancellable?
    private let width = PassthroughSubject<CGFloat, Never>()
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let attributes = [
            NSAttributedString.Key.font: NSFont.systemFont(ofSize: 12, weight: .regular),
            .foregroundColor: NSColor.white]
        
        let height = heightAnchor.constraint(equalToConstant: 0)
        height.isActive = true
        
        let color = NSColor(named: "Spot")!.cgColor
        
        sub = tags
            .combineLatest(width)
            .removeDuplicates {
                $0.0 == $1.0 && $0.1 == $1.1
            }
            .map { tags, width -> Model in
                var x = CGFloat()
                var y = CGFloat()
                var last = CGFloat()
                var model = Model()
                
                for tag in tags {
                    let string = NSAttributedString.make(tag, attributes: attributes)
                    let size = CGSize(width: string.width(for: 16) + 24, height: 22)
                    
                    if x + size.width > width {
                        x = 0
                        y += 6 + last
                        last = 0
                    }
                    
                    last = max(last, size.height)
                    model.items.append(.init(string: string, frame: .init(origin: .init(x: x, y: y), size: size)))
                    x += 6 + size.width
                }
                
                model.height = y + last
                return model
            }
            .removeDuplicates()
            .sink { [weak self] model in
                guard let self = self else { return }

                self
                    .subviews
                    .forEach {
                        $0.removeFromSuperview()
                    }
                
                model
                    .items
                    .forEach {
                        self.addSubview(Item(tag: $0.string, frame: $0.frame, color: color))
                    }
                
                height.constant = model.height
            }
    }
    
    override func hitTest(_: NSPoint) -> NSView? {
        nil
    }
}
