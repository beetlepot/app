import AppKit

extension Bar {
    final class Option: Control {
        required init?(coder: NSCoder) { nil }
        init(icon: String, size: CGFloat) {
            let image = Image(icon: icon)
            image.symbolConfiguration = .init(pointSize: size, weight: .regular)
                .applying(.init(hierarchicalColor: .secondaryLabelColor))
            
            super.init(layer: true)
            layer!.cornerRadius = 8
            layer!.cornerCurve = .continuous
            
            addSubview(image)
            widthAnchor.constraint(equalToConstant: 30).isActive = true
            heightAnchor.constraint(equalTo: widthAnchor).isActive = true
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .pressed, .highlighted:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
            default:
                layer!.backgroundColor = .clear
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
