import AppKit

extension Tags {
    final class Cell: CollectionCell<Info> {
        static let height = CGFloat(66)
        private weak var text: CollectionCellText!
        private weak var separator: Shape!
        
        override var item: CollectionItem<Info>? {
            didSet {
                guard
                    item != oldValue,
                    let item = item
                else { return }
                
                if item.rect != oldValue?.rect {
                    frame = item.rect
                    separator.path = .init(rect: .init(x: 17, y: -0.5, width: item.rect.size.width - 34, height: 0), transform: nil)
                    
                    let width = item.rect.size.width - 86
                    let height = item.info.text.height(for: width)
                    text.frame = .init(
                        x: 64,
                        y: (Self.height - height) / 2,
                        width: width,
                        height: height)
                    separator.isHidden = item.info.id == 0
                }
                
                if item.info != oldValue?.info {
                    text.string = item.info.text
                }
            }
        }
        
        required init?(coder: NSCoder) { nil }
        override init(layer: Any) { super.init(layer: layer) }
        required init() {
            super.init()
            cornerCurve = .continuous
            cornerRadius = 10
            
            let text = CollectionCellText()
            addSublayer(text)
            self.text = text
            
            let separator = Shape()
            separator.fillColor = .clear
            separator.lineWidth = 1
            separator.strokeColor = NSColor.separatorColor.cgColor
            addSublayer(separator)
            self.separator = separator
        }
        
        override func update() {
            switch state {
            case .highlighted, .pressed:
                backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
            default:
                backgroundColor = .clear
            }
        }
    }
}
