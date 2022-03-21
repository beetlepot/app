import AppKit
import Combine

final class Reveal: NSView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(id: Int) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let flip = Flip()
        flip.translatesAutoresizingMaskIntoConstraints = false
        
        let scroll = NSScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.documentView = flip
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        scroll.drawsBackground = false
        scroll.scrollerInsets.bottom = 10
        scroll.automaticallyAdjustsContentInsets = false
        scroll.postsBoundsChangedNotifications = true
        addSubview(scroll)
        
        let separator = Separator(mode: .horizontal)
        separator.isHidden = true
        addSubview(separator)
        
        let text = Text(vibrancy: true)
        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        flip.addSubview(text)
        
        let tagger = Tagger()
        flip.addSubview(tagger)
        
        scroll.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: rightAnchor, constant: -1).isActive = true
        scroll.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1).isActive = true
        
        flip.topAnchor.constraint(equalTo: scroll.topAnchor).isActive = true
        flip.leftAnchor.constraint(equalTo: scroll.leftAnchor).isActive = true
        flip.rightAnchor.constraint(equalTo: scroll.rightAnchor).isActive = true
        
        separator.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        separator.leftAnchor.constraint(equalTo: text.leftAnchor, constant: -20).isActive = true
        separator.rightAnchor.constraint(equalTo: text.rightAnchor, constant: 20).isActive = true
        
        text.topAnchor.constraint(equalTo: tagger.bottomAnchor, constant: 20).isActive = true
        text.leftAnchor.constraint(greaterThanOrEqualTo: flip.leftAnchor, constant: 40).isActive = true
        text.rightAnchor.constraint(lessThanOrEqualTo: flip.rightAnchor, constant: -40).isActive = true
        text.centerXAnchor.constraint(equalTo: flip.centerXAnchor).isActive = true
        text.widthAnchor.constraint(lessThanOrEqualToConstant: 600).isActive = true
        text.bottomAnchor.constraint(lessThanOrEqualTo: flip.bottomAnchor, constant: -40).isActive = true
        
        let left = text.leftAnchor.constraint(equalTo: flip.leftAnchor, constant: 40)
        left.priority = .defaultLow
        left.isActive = true
        
        let width = text.widthAnchor.constraint(equalToConstant: 600)
        width.priority = .defaultLow
        width.isActive = true
        
        tagger.topAnchor.constraint(equalTo: flip.topAnchor, constant: 20).isActive = true
        tagger.leftAnchor.constraint(equalTo: text.leftAnchor).isActive = true
        tagger.rightAnchor.constraint(equalTo: text.rightAnchor).isActive = true
        
        cloud
            .map {
                $0[id]
            }
            .removeDuplicates()
            .sink { secret in
                text.attributedStringValue = .make {
                    $0.append(.with(markdown: secret.name, attributes: [
                        .foregroundColor: NSColor.labelColor,
                        .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title1).pointSize, weight: .light)]))
                    $0.newLine()
                    if !secret.payload.isEmpty {
                        $0.newLine()
                        $0.append(.with(markdown: secret.payload, attributes: [
                            .foregroundColor: NSColor.secondaryLabelColor,
                            .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .regular)]))
                        $0.newLine()
                    }
                    $0.append(.make("Updated " + secret.date.formatted(.relative(presentation: .named, unitsStyle: .wide)), attributes: [
                        .foregroundColor: NSColor.tertiaryLabelColor,
                        .font: NSFont.preferredFont(forTextStyle: .callout)]))
                }
                
                tagger.tags.send(secret
                                    .tags
                                    .list)
            }
            .store(in: &subs)
        
        NotificationCenter
            .default
            .publisher(for: NSView.boundsDidChangeNotification)
            .compactMap {
                $0.object as? NSClipView
            }
            .filter {
                $0 == scroll.contentView
            }
            .map {
                $0.bounds.minY < 20
            }
            .removeDuplicates()
            .sink {
                separator.isHidden = $0
            }
            .store(in: &subs)
    }
}
