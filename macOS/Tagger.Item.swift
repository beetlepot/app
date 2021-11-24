import AppKit

extension Tagger {
    final class Item: NSView {
        required init?(coder: NSCoder) { nil }
        init(tag: NSAttributedString, frame: CGRect, color: CGColor) {
            super.init(frame: frame)
            layer = Layer()
            wantsLayer = true
            layer!.backgroundColor = color
            layer!.cornerRadius = 11
            
            let text = Text(vibrancy: false)
            text.attributedStringValue = tag
            addSubview(text)
            
            text.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            text.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
        }
    }
}
