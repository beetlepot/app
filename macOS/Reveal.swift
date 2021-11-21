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
        
        let text = Text(vibrancy: true)
        text.attributedStringValue = .make {
            $0.append(.with(markdown: secret.name, attributes: [
                .foregroundColor: NSColor.labelColor,
                .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title1).pointSize, weight: .light)]))
            $0.newLine()
            $0.newLine()
            $0.append(.with(markdown: secret.payload, attributes: [
                .foregroundColor: NSColor.labelColor,
                .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .regular)]))
            $0.newLine()
            $0.append(.make("Updated " + secret.date.formatted(.relative(presentation: .named, unitsStyle: .wide)), attributes: [
                .foregroundColor: NSColor.tertiaryLabelColor,
                .font: NSFont.preferredFont(forTextStyle: .footnote)]))
        }
        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        flip.addSubview(text)
        
        flip.topAnchor.constraint(equalTo: topAnchor).isActive = true
        flip.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        flip.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        text.topAnchor.constraint(equalTo: flip.topAnchor, constant: 20).isActive = true
        text.leftAnchor.constraint(equalTo: flip.leftAnchor, constant: 40).isActive = true
        text.rightAnchor.constraint(equalTo: flip.rightAnchor, constant: -40).isActive = true
        text.bottomAnchor.constraint(lessThanOrEqualTo: flip.bottomAnchor, constant: -40).isActive = true
    }
}
