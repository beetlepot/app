import AppKit
import Combine
import UserNotifications

final class Edit: NSPanel, NSTextFieldDelegate {
    private static let width = CGFloat(440)
    private weak var name: Field!
    private weak var textview: Textview!
    private var monitor: Any?
    private var subs = Set<AnyCancellable>()
    private let id: Int
    
    override var canBecomeKey: Bool {
        true
    }
    
    deinit {
        print("edit gone")
    }
    
    init(id: Int) {
        self.id = id
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
        name.delegate = self
        self.name = name
        blur.addSubview(name)
        
        let separator = Separator(mode: .horizontal)
        blur.addSubview(separator)
        
        let textview = Textview()
        textview.textContainer!.size.width = Self.width - ((textview.textContainerInset.width * 2) + 2)
        self.textview = textview
        
        let scroll = NSScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.documentView = textview
        scroll.drawsBackground = false
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        scroll.scrollerInsets.bottom = 20
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
        separator.leftAnchor.constraint(equalTo: name.leftAnchor, constant: 12).isActive = true
        separator.rightAnchor.constraint(equalTo: name.rightAnchor, constant: -12).isActive = true
        
        scroll.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: blur.leftAnchor, constant: 1).isActive = true
        scroll.rightAnchor.constraint(equalTo: blur.rightAnchor, constant: -1).isActive = true
        scroll.bottomAnchor.constraint(equalTo: blur.bottomAnchor, constant: -1).isActive = true
        
        cloud
            .map {
                $0[id]
            }
            .removeDuplicates()
            .sink { secret in
                name.stringValue = secret.name
                textview.string = secret.payload
            }
            .store(in: &subs)
        
        save
            .click
            .sink { [weak self] in
                self?.save()
            }
            .store(in: &subs)
        
        monitor = NSEvent
            .addLocalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown, .otherMouseDown]) { [weak self] event in
                if self?.isVisible == true && event.window != self {
                    self?.close()
                }
                return event
            }
    }
    
    func control(_: NSControl, textView: NSTextView, doCommandBy: Selector) -> Bool {
        switch doCommandBy {
        case #selector(cancelOperation),
            #selector(complete),
            #selector(NSSavePanel.cancel),
            #selector(insertNewline),
            #selector(moveUp),
            #selector(moveDown),
            #selector(insertTab),
            #selector(insertBacktab):
            makeFirstResponder(textview)
            textview.setSelectedRange(.init(location: 0, length: 0))
        default:
            return false
        }
        return true
    }
    
    override func keyDown(with: NSEvent) {
        switch with.keyCode {
        case 36:
            save()
        default:
            super.keyDown(with: with)
        }
    }
    
    override func close() {
        monitor
            .map(NSEvent.removeMonitor)
        monitor = nil

        name.undoManager?.removeAllActions()
        textview.undoManager?.removeAllActions()
        
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
    
    private func save() {
        let name = name.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        let payload = textview.string.trimmingCharacters(in: .whitespacesAndNewlines)
        let id = self.id
        
        Task
            .detached(priority: .utility) {
                await cloud.update(id: id, name: name, payload: payload)
                await UNUserNotificationCenter.send(message: "Edited secret!")
            }
        
        close()
    }
}
