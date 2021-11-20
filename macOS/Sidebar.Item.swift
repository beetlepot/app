import AppKit
import Secrets

extension Sidebar {
    final class Item: Control {
        private weak var background: Vibrant!
        
        required init?(coder: NSCoder) { nil }
        init(secret: Secret) {
            let background = Vibrant(layer: true)
            background.layer!.cornerRadius = 12
            background.layer!.cornerCurve = .continuous
            self.background = background
            
            super.init(layer: false)
            addSubview(background)
            
            let text = Text(vibrancy: true)
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            text.attributedStringValue = .with(markdown: secret.name, attributes: [
                .foregroundColor: NSColor.secondaryLabelColor,
                .font: NSFont.preferredFont(forTextStyle: .body)])
            addSubview(text)
            
            bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: 14).isActive = true
            
            background.topAnchor.constraint(equalTo: topAnchor).isActive = true
            background.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            background.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            background.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            
            text.topAnchor.constraint(equalTo: topAnchor, constant: 14).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true
            text.rightAnchor.constraint(equalTo: rightAnchor, constant: -14).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            switch state {
            case .selected:
                background.layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.15).cgColor
            case .pressed, .highlighted:
                background.layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
            default:
                background.layer!.backgroundColor = .clear
            }
        }
    }
}
