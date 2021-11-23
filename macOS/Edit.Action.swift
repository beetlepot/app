import AppKit

extension Edit {
    final class Action: Control {
        required init?(coder: NSCoder) { nil }
        init(title: String) {
            let text = Text(vibrancy: false)
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .body)
            text.textColor = .white
        
            super.init(layer: true)
            layer!.cornerRadius = 11
            layer!.backgroundColor = NSColor.controlAccentColor.cgColor
            addSubview(text)
            
            heightAnchor.constraint(equalToConstant: 28).isActive = true
            rightAnchor.constraint(equalTo: text.rightAnchor, constant: 18).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 18).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            switch state {
            case .pressed:
                alphaValue = 0.75
            default:
                alphaValue = 1
            }
        }
    }
}
