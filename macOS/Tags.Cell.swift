import AppKit

extension Tags {
    final class Cell: CollectionCell<Info> {
        static let height = CGFloat(40)
        private weak var text: Text!
        private weak var separator: Shape!
        private weak var icon: Image!
        
        override var item: CollectionItem<Info>? {
            didSet {
                guard
                    item != oldValue,
                    let item = item
                else { return }
                
                separator.isHidden = item.info.first
                
                if item.rect != oldValue?.rect {
                    frame = item.rect
                    separator.path = .init(rect: .init(x: 0, y: 40.5, width: item.rect.size.width, height: 0), transform: nil)
                    
                    let width = item.rect.size.width - 40
                    let height = item.info.text.height(for: width)
                    text.frame = .init(
                        x: 0,
                        y: (Self.height - height) / 2,
                        width: width,
                        height: height)
                }
                
                if item.info != oldValue?.info {
                    text.attributedStringValue = item.info.text
                    icon.isHidden = !item.info.active
                }
            }
        }
        
        required init?(coder: NSCoder) { nil }
        required init() {
            let separator = Shape()
            separator.fillColor = .clear
            separator.lineWidth = 1
            self.separator = separator
            
            super.init()
            layer!.masksToBounds = false
            
            let text = Text(vibrancy: true)
            text.translatesAutoresizingMaskIntoConstraints = true
            self.text = text
            addSubview(text)
            
            let icon = Image(icon: "checkmark.circle.fill")
            icon.frame = .init(x: 144, y: 10, width: 25, height: 25)
            icon.symbolConfiguration = .init(pointSize: 20, weight: .light)
                .applying(.init(hierarchicalColor: .secondaryLabelColor))
            self.icon = icon
            addSubview(icon)
            
            layer!.addSublayer(separator)
        }
        
        override func updateLayer() {
            separator.strokeColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
        }
    }
}
