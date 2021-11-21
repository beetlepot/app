import AppKit

extension Purchases {
    final class Indicator: Control {
        let id: String
        
        required init?(coder: NSCoder) { nil }
        init(id: String) {
            self.id = id
            super.init(layer: true)
            layer!.cornerRadius = 4
            
            widthAnchor.constraint(equalToConstant: 8).isActive = true
            heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            switch state {
            case .highlighted, .pressed, .selected:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.4).cgColor
            default:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
