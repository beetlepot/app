import AppKit

extension Sidebar {
    final class Active: Control {
        private weak var image: Image!
        
        required init?(coder: NSCoder) { nil }
        init(icon: String) {
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
                image.symbolConfiguration = .init(pointSize: 21, weight: .regular)
                    .applying(.init(hierarchicalColor: .controlAccentColor.withAlphaComponent(0.7)))
            default:
                image.symbolConfiguration = .init(pointSize: 21, weight: .regular)
                    .applying(.init(hierarchicalColor: .controlAccentColor))
            }
        }
    }
}
