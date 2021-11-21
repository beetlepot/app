import AppKit

extension Purchases.Products {
    final class Action: Control {
        required init?(coder: NSCoder) { nil }
        init() {
            let text = Text(vibrancy: false)
            text.stringValue = "Purchase"
            text.font = .preferredFont(forTextStyle: .body)
            text.textColor = .white
        
            super.init(layer: true)
            layer!.cornerRadius = 17
            layer!.backgroundColor = NSColor.controlAccentColor.cgColor
            addSubview(text)
            
            heightAnchor.constraint(equalToConstant: 34).isActive = true
            rightAnchor.constraint(equalTo: text.rightAnchor, constant: 24).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
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
