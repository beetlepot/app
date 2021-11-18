import AppKit

extension Landing {
    final class Option: Control {
        private(set) weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init(title: String, symbol: String) {
            let text = Text(vibrancy: false)
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .title3)
            text.textColor = .secondaryLabelColor
            self.text = text
            
            let icon = Image(icon: symbol)
            icon.symbolConfiguration = .init(textStyle: .title2)
            icon.contentTintColor = .secondaryLabelColor
            
            super.init(layer: true)
            layer!.cornerRadius = 6
            addSubview(text)
            addSubview(icon)
            
            heightAnchor.constraint(equalToConstant: 36).isActive = true
            widthAnchor.constraint(equalToConstant: 180).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 8).isActive = true
            
            icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
            icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
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
