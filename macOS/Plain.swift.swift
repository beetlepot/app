import AppKit

final class Plain: Control {
    private weak var text: Text!
    
    required init?(coder: NSCoder) { nil }
    init(title: String) {
        let text = Text(vibrancy: false)
        text.stringValue = title
        text.font = .preferredFont(forTextStyle: .body)
        self.text = text
        
        super.init(layer: false)
        addSubview(text)
        
        heightAnchor.constraint(equalToConstant: 30).isActive = true
        rightAnchor.constraint(equalTo: text.rightAnchor, constant: 5).isActive = true
        
        text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        text.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
    }
    
    override func update() {
        super.update()
        
        switch state {
        case .pressed, .highlighted:
            text.textColor = .labelColor
        default:
            text.textColor = .secondaryLabelColor
        }
    }
}
