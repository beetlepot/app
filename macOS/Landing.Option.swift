import AppKit

extension Landing {
    final class Option: Control {
        private(set) weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init(title: String, symbol: String) {
            let text = Text(vibrancy: false)
            text.stringValue = title
            text.font = .systemFont(ofSize: 15, weight: .light)
            text.textColor = .secondaryLabelColor
            self.text = text
            
            let icon = Image(icon: symbol)
            icon.symbolConfiguration = .init(pointSize: 18, weight: .light)
            icon.contentTintColor = .secondaryLabelColor
            
            super.init(layer: true)
            layer!.cornerRadius = 6
            addSubview(text)
            addSubview(icon)
            
            heightAnchor.constraint(equalToConstant: 36).isActive = true
            widthAnchor.constraint(equalToConstant: 144).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 8).isActive = true
            
            icon.centerXAnchor.constraint(equalTo: leftAnchor, constant: 22).isActive = true
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
