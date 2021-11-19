import AppKit
import Secrets

final class Reveal: NSScrollView {
    required init?(coder: NSCoder) { nil }
    init(secret: Secret) {
        let flip = Flip()
        flip.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        verticalScrollElasticity = .none
        documentView = flip
        hasVerticalScroller = true
        verticalScroller!.controlSize = .mini
        drawsBackground = false
        
        let string = AttributedString.with(markdown: secret.name, attributes: .init([
            .foregroundColor: NSColor.labelColor,
            .font: NSFont.preferredFont(forTextStyle: .title1)]))
        + .newLine
        + .newLine
        + .with(markdown: secret.payload, attributes: .init([
            .foregroundColor: NSColor.labelColor,
            .font: NSFont.preferredFont(forTextStyle: .title3)]))
        + .newLine
        + .with(markdown: "Updated " + secret.date.formatted(.relative(presentation: .named, unitsStyle: .wide)), attributes: .init([
            .foregroundColor: NSColor.tertiaryLabelColor,
            .font: NSFont.preferredFont(forTextStyle: .footnote)]))
        
        let text = Text(vibrancy: true)
        text.attributedStringValue = .init(string)
        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        flip.addSubview(text)
        
        flip.topAnchor.constraint(equalTo: topAnchor).isActive = true
        flip.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        flip.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        text.topAnchor.constraint(equalTo: flip.topAnchor, constant: 20).isActive = true
        text.leftAnchor.constraint(equalTo: flip.leftAnchor, constant: 20).isActive = true
        text.rightAnchor.constraint(equalTo: flip.rightAnchor, constant: -40).isActive = true
        text.bottomAnchor.constraint(lessThanOrEqualTo: flip.bottomAnchor, constant: -40).isActive = true
    }
}
