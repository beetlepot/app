import AppKit

extension Share {
    final class Option: Control {
        private(set) weak var image: Image!
        private(set) weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init(title: String, image: String) {
            let image = Image(icon: image)
            image.symbolConfiguration = .init(textStyle: .title3)
                .applying(.init(hierarchicalColor: .secondaryLabelColor))
            self.image = image
            
            let text = Text(vibrancy: true)
            text.stringValue = title
            text.textColor = .secondaryLabelColor
            text.font = .preferredFont(forTextStyle: .body)
            self.text = text
            
            super.init(layer: true)
            layer!.cornerRadius = 6
            
            addSubview(image)
            addSubview(text)
            
            widthAnchor.constraint(equalToConstant: 130).isActive = true
            heightAnchor.constraint(equalToConstant: 34).isActive = true
            
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            image.centerXAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
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
