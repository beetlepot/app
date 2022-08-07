import AppKit
import LocalAuthentication
import Combine

final class Auth: NSWindow {
    override var isModalPanel: Bool {
        true
    }
    
    private weak var unlock: Plain!
    private weak var cancel: Plain!
    private var subs = Set<AnyCancellable>()
    
    init() {
        let unlock = Plain(title: "Unlock")
        self.unlock = unlock
        
        let cancel = Plain(title: "Close")
        self.cancel = cancel
        
        super.init(contentRect: .init(origin: .zero, size: .init(width: 240, height: 240)),
                   styleMask: [.borderless],
                   backing: .buffered,
                   defer: true)
        isOpaque = false
        backgroundColor = .clear
        hasShadow = true
        isReleasedWhenClosed = false
        center()
        
        let blur = NSVisualEffectView()
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.material = .hudWindow
        blur.state = .active
        blur.wantsLayer = true
        blur.layer!.cornerRadius = 20
        contentView!.addSubview(blur)
        
        blur.addSubview(unlock)
        blur.addSubview(cancel)
        
        let image = Image(icon: "touchid")
        image.symbolConfiguration = .init(pointSize: 50, weight: .thin)
            .applying(.init(hierarchicalColor: .secondaryLabelColor))
        blur.addSubview(image)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let string = NSMutableAttributedString()
        string.append(.init(string: "Beetle", attributes: [
            .font: NSFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor: NSColor.secondaryLabelColor,
            .paragraphStyle: paragraph]))
        string.append(.init(string: "\nis locked", attributes: [
            .font: NSFont.systemFont(ofSize: 14, weight: .regular),
            .foregroundColor: NSColor.tertiaryLabelColor,
            .paragraphStyle: paragraph]))
        
        let text = Text(vibrancy: true)
        text.attributedStringValue = string
        blur.addSubview(text)
        
        blur.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        
        image.topAnchor.constraint(equalTo: blur.topAnchor, constant: 40).isActive = true
        image.centerXAnchor.constraint(equalTo: blur.centerXAnchor).isActive = true
        
        text.centerXAnchor.constraint(equalTo: blur.centerXAnchor).isActive = true
        text.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
        
        unlock.centerXAnchor.constraint(equalTo: blur.centerXAnchor).isActive = true
        unlock.bottomAnchor.constraint(equalTo: cancel.topAnchor).isActive = true
        
        cancel.centerXAnchor.constraint(equalTo: blur.centerXAnchor).isActive = true
        cancel.bottomAnchor.constraint(equalTo: blur.bottomAnchor, constant: -25).isActive = true
        
        unlock
            .click
            .sink { [weak self] in
                self?.auth()
            }
            .store(in: &subs)
        
        cancel
            .click
            .sink { [weak self] in
                self?.cancelOperation(nil)
            }
            .store(in: &subs)
        
        auth()
    }
    
    override func close() {
        NSApp.stopModal()
        super.close()
    }
    
    override func keyDown(with: NSEvent) {
        switch with.keyCode {
        case 36:
            cancelOperation(nil)
        default:
            super.keyDown(with: with)
        }
    }
    
    override func cancelOperation(_: Any?) {
        close()
        NSApp.terminate(nil)
    }
    
    override var canBecomeKey: Bool {
        true
    }
    
    private func auth() {
        unlock.state = .hidden
        cancel.state = .hidden
        
        let context = LAContext()
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) else {
            authenticated()
            return
        }

        context
            .evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Authenticate to access your secrets") { [weak self] in
                guard $0, $1 == nil else {
                    DispatchQueue.main.async { [weak self] in
                        self?.unlock.state = .on
                        self?.cancel.state = .on
                        
                        NSApp.activate(ignoringOtherApps: true)
                        self?.makeKeyAndOrderFront(nil)
                        self?.orderFrontRegardless()
                    }
                    return
                }
                
                DispatchQueue
                    .main
                    .async { [weak self] in
                        self?.authenticated()
                    }
            }
    }
    
    private func authenticated() {
        NSApp.activate(ignoringOtherApps: true)
        
        let window = Window()
        window.makeKeyAndOrderFront(nil)
        close()
        window.orderFrontRegardless()
    }
}
