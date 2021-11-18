import AppKit

final class Window: NSWindow, NSWindowDelegate {
    init() {
        super.init(contentRect: .init(x: 0,
                                      y: 0,
                                      width: 600,
                                      height: 400),
                   styleMask: [.closable, .miniaturizable, .resizable, .titled, .fullSizeContentView],
                   backing: .buffered,
                   defer: false)
        minSize = .init(width: 400, height: 200)
        toolbar = .init()
        isReleasedWhenClosed = false
        center()
//        setFrameAutosaveName("Window")
        tabbingMode = .disallowed
        titlebarAppearsTransparent = true
        
        let top = NSTitlebarAccessoryViewController()
        top.view = Bar()
        top.layoutAttribute = .top
        addTitlebarAccessoryViewController(top)
        
        let base = NSVisualEffectView()
        base.material = .menu
        base.state = .active
        contentView = base
        
        let content = NSView()
        content.translatesAutoresizingMaskIntoConstraints = false
        base.addSubview(content)
        
        content.topAnchor.constraint(equalTo: base.safeAreaLayoutGuide.topAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: base.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        content.bottomAnchor.constraint(equalTo: base.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
    }
    
    override func close() {
        super.close()
        NSApp.terminate(nil)
    }
    
    func windowDidEnterFullScreen(_: Notification) {
        titlebarAccessoryViewControllers
            .compactMap {
                $0.view as? NSVisualEffectView
            }
            .forEach {
                $0.material = .sheet
            }
    }
    
    func windowDidExitFullScreen(_: Notification) {
        titlebarAccessoryViewControllers
            .compactMap {
                $0.view as? NSVisualEffectView
            }
            .forEach {
                $0.material = .menu
            }
    }
}
