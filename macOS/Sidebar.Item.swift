import AppKit
import Secrets

extension Sidebar {
    final class Item: Control {
        required init?(coder: NSCoder) { nil }
        init(secret: Secret) {
            super.init(layer: true)
            layer!.cornerRadius = 12
            layer!.cornerCurve = .continuous
            
            let text = Text(vibrancy: true)
            text.attributedStringValue = .init(.with(markdown: secret.name, attributes: .init([
                .foregroundColor: NSColor.secondaryLabelColor,
                .font: NSFont.preferredFont(forTextStyle: .body)])))
            addSubview(text)
            
            bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: 14).isActive = true
            
            text.topAnchor.constraint(equalTo: topAnchor, constant: 14).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true
            text.rightAnchor.constraint(equalTo: rightAnchor, constant: -14).isActive = true
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .selected:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.15).cgColor
            case .pressed, .highlighted:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
            default:
                layer!.backgroundColor = .clear
            }
        }
    }
}
