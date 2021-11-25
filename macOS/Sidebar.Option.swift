import AppKit

extension Sidebar {
    final class Option: Control {
        private weak var image: Image!
        private let size: CGFloat
        
        required init?(coder: NSCoder) { nil }
        init(icon: String, size: CGFloat) {
            self.size = size
            
            let image = Image(icon: icon)
            self.image = image
            
            super.init(layer: false)
            
            addSubview(image)
            widthAnchor.constraint(equalToConstant: 30).isActive = true
            heightAnchor.constraint(equalTo: widthAnchor).isActive = true
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            switch state {
            case .highlighted, .pressed:
                image.symbolConfiguration = .init(pointSize: size, weight: .regular)
                    .applying(.init(hierarchicalColor: .labelColor))
            default:
                image.symbolConfiguration = .init(pointSize: size, weight: .regular)
                    .applying(.init(hierarchicalColor: .secondaryLabelColor))
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
