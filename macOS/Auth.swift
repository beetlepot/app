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
        text.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .light)
        text.textColor = .secondaryLabelColor
        blur.addSubview(text)
        
        blur.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        
        image.centerYAnchor.constraint(equalTo: blur.centerYAnchor).isActive = true
        image.centerXAnchor.constraint(equalTo: blur.centerXAnchor).isActive = true
        
        text.centerXAnchor.constraint(equalTo: blur.centerXAnchor).isActive = true
        text.bottomAnchor.constraint(equalTo: blur.bottomAnchor, constant: -60).isActive = true
        
        let context = LAContext()
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) else {
            authenticated()
            return
        }

        context
            .evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Authenticate to access your secrets") {
                guard $0, $1 == nil else { return }
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
