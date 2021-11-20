import AppKit

final class Action: Control {
    required init?(coder: NSCoder) { nil }
    init(title: String, color: NSColor) {
        let text = Text(vibrancy: false)
        text.stringValue = title
        text.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .medium)
        text.textColor = .white
    
        super.init(layer: true)
        layer!.cornerRadius = 9
        layer!.backgroundColor = color.cgColor
        addSubview(text)
        
        heightAnchor.constraint(equalToConstant: 34).isActive = true
        rightAnchor.constraint(equalTo: text.rightAnchor, constant: 16).isActive = true
        
        text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        text.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
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
