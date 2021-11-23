import AppKit
import Combine
import Secrets

final class Edit: NSPanel {
    private var monitor: Any?
    private var subs = Set<AnyCancellable>()
    
    deinit {
        print("edit gone")
    }
    
    init(secret: Secret) {
        super.init(contentRect: .init(origin: .zero, size: .init(width: 400, height: 500)),
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
        blur.material = .menu
        blur.state = .active
        blur.wantsLayer = true
        blur.layer!.cornerRadius = 20
        contentView!.addSubview(blur)
        
        let vibrant = Vibrant(layer: false)
        vibrant.translatesAutoresizingMaskIntoConstraints = false
        blur.addSubview(vibrant)
        
        let title = Text(vibrancy: true)
        title.stringValue = "Edit"
        title.font = .preferredFont(forTextStyle: .title2)
        title.textColor = .tertiaryLabelColor
        vibrant.addSubview(title)
        
        let icon = Image(icon: "pencil.circle.fill")
        icon.symbolConfiguration = .init(textStyle: .title1)
            .applying(.init(hierarchicalColor: .tertiaryLabelColor))
        vibrant.addSubview(icon)
        
        let save = Action(title: "Save", color: .controlAccentColor)
        save
            .click
            .sink { [weak self] in
                self?.close()
            }
            .store(in: &subs)
        blur.addSubview(save)
        
        let cancel = Plain(title: "Cancel")
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
        
        vibrant.topAnchor.constraint(equalTo: blur.topAnchor).isActive = true
        vibrant.centerXAnchor.constraint(equalTo: blur.centerXAnchor).isActive = true
        vibrant.heightAnchor.constraint(equalToConstant: 52).isActive = true
        vibrant.rightAnchor.constraint(equalTo: icon.rightAnchor).isActive = true
        
        title.centerYAnchor.constraint(equalTo: vibrant.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: vibrant.leftAnchor).isActive = true
        
        icon.leftAnchor.constraint(equalTo: title.rightAnchor, constant: 10).isActive = true
        icon.centerYAnchor.constraint(equalTo: vibrant.centerYAnchor).isActive = true
        
        save.rightAnchor.constraint(equalTo: blur.rightAnchor, constant: -10).isActive = true
        save.centerYAnchor.constraint(equalTo: vibrant.centerYAnchor).isActive = true
        
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
    
    override func close() {
        monitor
            .map(NSEvent.removeMonitor)
        monitor = nil
        parent?.removeChildWindow(self)
        super.close()
    }
    
    override func cancelOperation(_: Any?) {
        close()
    }
    
    override var canBecomeKey: Bool {
        true
    }
}
