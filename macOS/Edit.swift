import AppKit
import Combine
import Secrets

final class Edit: NSPanel {
    private static let width = CGFloat(440)
    private weak var name: Field!
    private var monitor: Any?
    private var subs = Set<AnyCancellable>()
    
    override var canBecomeKey: Bool {
        true
    }
    
    deinit {
        print("edit gone")
    }
    
    init(secret: Secret) {
        super.init(contentRect: .init(origin: .zero, size: .init(width: Self.width, height: 500)),
                   styleMask: [.borderless],
                   backing: .buffered,
                   defer: true)
        isOpaque = false
        isMovableByWindowBackground = true
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
        
        let title = Text(vibrancy: true)
        title.stringValue = "Edit"
        title.font = .preferredFont(forTextStyle: .title3)
        title.textColor = .tertiaryLabelColor
        blur.addSubview(title)
        
        let save = Action(title: "Save")
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
        
        let name = Field()
        name.stringValue = secret.name
        self.name = name
        blur.addSubview(name)
        
        let separator = Separator(mode: .horizontal)
        blur.addSubview(separator)
        
        let textview = Textview()
        textview.textContainer!.size.width = Self.width - (textview.textContainerInset.width * 2)
        textview.string = secret.payload
        
        let scroll = NSScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.documentView = textview
        scroll.drawsBackground = false
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        scroll.scrollerInsets.bottom = 12
        scroll.automaticallyAdjustsContentInsets = false
        blur.addSubview(scroll)
        
        blur.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        
        title.centerYAnchor.constraint(equalTo: blur.topAnchor, constant: 26).isActive = true
        title.leftAnchor.constraint(equalTo: blur.leftAnchor, constant: 20).isActive = true
        
        save.rightAnchor.constraint(equalTo: blur.rightAnchor, constant: -13).isActive = true
        save.centerYAnchor.constraint(equalTo: blur.topAnchor, constant: 26).isActive = true
        
        cancel.rightAnchor.constraint(equalTo: save.leftAnchor, constant: -10).isActive = true
        cancel.centerYAnchor.constraint(equalTo: blur.topAnchor, constant: 26).isActive = true
        
        name.topAnchor.constraint(equalTo: blur.topAnchor, constant: 70).isActive = true
        name.leftAnchor.constraint(equalTo: blur.leftAnchor, constant: 12).isActive = true
        name.rightAnchor.constraint(equalTo: blur.rightAnchor, constant: -12).isActive = true
        
        separator.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 20).isActive = true
        separator.leftAnchor.constraint(equalTo: name.leftAnchor, constant: 10).isActive = true
        separator.rightAnchor.constraint(equalTo: name.rightAnchor, constant: -10).isActive = true
        
        scroll.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: blur.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: blur.rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: blur.bottomAnchor).isActive = true
        
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

        name.undoManager?.removeAllActions()
        
        parent?.removeChildWindow(self)
        super.close()
    }
    
    override func cancelOperation(_: Any?) {
        close()
    }
    
    override func mouseDown(with: NSEvent) {
        super.mouseDown(with: with)
        if with.clickCount == 1 {
            makeFirstResponder(nil)
        }
    }
}
