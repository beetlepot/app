import AppKit
import LocalAuthentication

final class Auth: NSWindow {
    override var isModalPanel: Bool {
        true
    }
    
    init() {
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
        
        let image = Image(icon: "touchid")
        image.symbolConfiguration = .init(pointSize: 50, weight: .thin)
            .applying(.init(hierarchicalColor: .secondaryLabelColor))
        blur.addSubview(image)
        
        let text = Text(vibrancy: true)
        
        text.stringValue = "Beetle is locked"
        text.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .medium)
        text.textColor = .secondaryLabelColor
        blur.addSubview(text)
        
        blur.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        
        image.topAnchor.constraint(equalTo: blur.topAnchor, constant: 50).isActive = true
        image.centerXAnchor.constraint(equalTo: blur.centerXAnchor).isActive = true
        
        text.centerXAnchor.constraint(equalTo: blur.centerXAnchor).isActive = true
        text.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
        
        let context = LAContext()
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) else {
            authenticated()
            return
        }

        context
            .evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Authenticate to access your secrets") { [weak self] in
                guard $0, $1 == nil else {
                    DispatchQueue.main.async { [weak self] in
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
    
    override func close() {
        NSApp.stopModal()
        super.close()
    }
    
    override func cancelOperation(_: Any?) {
        close()
        NSApp.terminate(nil)
    }
    
    override var canBecomeKey: Bool {
        true
    }
    
    private func authenticated() {
        let window = Window()
        window.makeKeyAndOrderFront(nil)
        close()
        window.orderFrontRegardless()
    }
}
