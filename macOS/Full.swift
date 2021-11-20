import AppKit
import Combine

final class Full: NSPanel {
    private var monitor: Any?
    private var subs = Set<AnyCancellable>()

    init() {
        super.init(contentRect: .init(origin: .zero, size: .init(width: 280, height: 370)),
                   styleMask: [.borderless],
                   backing: .buffered,
                   defer: true)
        isOpaque = false
        backgroundColor = .clear
        hasShadow = true
        animationBehavior = .alertPanel
        center()
        
        let blur = NSVisualEffectView()
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.material = .hudWindow
        blur.state = .active
        blur.wantsLayer = true
        blur.layer!.cornerRadius = 20
        contentView!.addSubview(blur)
        
        let image = Image(named: "full")
        blur.addSubview(image)
        
        let text = Text(vibrancy: true)
        text.attributedStringValue = .with(markdown: Copy.full, attributes: [
            .foregroundColor: NSColor.secondaryLabelColor,
            .font: NSFont.preferredFont(forTextStyle: .body)])
        blur.addSubview(text)
        
        let purchases = Action(title: "In-App Purchases", color: .controlAccentColor)
        purchases
            .click
            .sink { [weak self] in
                self?.close()
                NSApp.showPurchases()
            }
            .store(in: &subs)
        blur.addSubview(purchases)
        
        let cancel = Plain(title: "Dismiss")
        cancel
            .click
            .sink { [weak self] in
                self?.close()
            }
            .store(in: &subs)
        blur.addSubview(cancel)
        
        blur.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        
        image.topAnchor.constraint(equalTo: blur.topAnchor, constant: 50).isActive = true
        image.centerXAnchor.constraint(equalTo: blur.centerXAnchor).isActive = true
        
        text.centerXAnchor.constraint(equalTo: blur.centerXAnchor).isActive = true
        text.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
        
        purchases.centerXAnchor.constraint(equalTo: blur.centerXAnchor).isActive = true
        purchases.bottomAnchor.constraint(equalTo: cancel.topAnchor, constant: -5).isActive = true
        
        cancel.centerXAnchor.constraint(equalTo: blur.centerXAnchor).isActive = true
        cancel.bottomAnchor.constraint(equalTo: blur.bottomAnchor, constant: -30).isActive = true
        
        monitor = NSEvent
            .addLocalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown, .otherMouseDown]) { [weak self] event in
                if self?.isVisible == true && event.window != self {
                    self?.close()
                }
                return event
            }
    }
    
    override func cancelOperation(_: Any?) {
        close()
    }
    
    override func close() {
        monitor
            .map(NSEvent.removeMonitor)
        monitor = nil
        parent?.removeChildWindow(self)
        super.close()
    }
    
    override var canBecomeKey: Bool {
        true
    }
}
