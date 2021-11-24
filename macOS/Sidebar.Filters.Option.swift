import AppKit

extension Sidebar {
    final class Option: Control {
        private weak var image: Image!
        private let vibrancy: Bool
        private let color: NSColor
        private let size: CGFloat
        
        required init?(coder: NSCoder) { nil }
        init(icon: String, size: CGFloat, color: NSColor = .secondaryLabelColor, vibrancy: Bool = true) {
            self.size = size
            self.color = color
            self.vibrancy = vibrancy
            
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
            
            image.symbolConfiguration = .init(pointSize: size, weight: .regular)
                .applying(.init(hierarchicalColor: color))
        }
        
        override var allowsVibrancy: Bool {
            vibrancy
        }
    }
}
