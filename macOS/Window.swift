import AppKit

final class Window: NSWindow, NSWindowDelegate {
    private weak var sidebar: Sidebar!
    private weak var content: NSView!
    
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
        
        let bar = Bar()
        
        let top = NSTitlebarAccessoryViewController()
        top.view = bar
        top.layoutAttribute = .top
        addTitlebarAccessoryViewController(top)
        
        let base = NSVisualEffectView()
        base.material = .menu
        base.state = .active
        contentView = base
        
        let content = NSView()
        content.translatesAutoresizingMaskIntoConstraints = false
        self.content = content
        base.addSubview(content)
        
        let sidebar = Sidebar(toggle: bar.sidebar)
        self.sidebar = sidebar
        base.addSubview(sidebar)
        
        content.topAnchor.constraint(equalTo: base.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        content.rightAnchor.constraint(equalTo: base.safeAreaLayoutGuide.rightAnchor, constant: -40).isActive = true
        content.bottomAnchor.constraint(equalTo: base.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        content.leftAnchor.constraint(equalTo: sidebar.rightAnchor, constant: 40).isActive = true
        
        sidebar.topAnchor.constraint(equalTo: base.safeAreaLayoutGuide.topAnchor).isActive = true
        sidebar.leftAnchor.constraint(equalTo: base.safeAreaLayoutGuide.leftAnchor).isActive = true
        sidebar.bottomAnchor.constraint(equalTo: base.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        landing()
    }
    
    override func close() {
        super.close()
        NSApp.terminate(nil)
    }
    
    func landing() {
        set(view: Landing())
    }
    
    private func set(view: NSView) {
        content
            .subviews
            .forEach {
                $0.removeFromSuperview()
            }
        
        content.addSubview(view)
        
        view.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
    }
    
    
    
    
    
    
    
//    func windowDidEnterFullScreen(_: Notification) {
//        titlebarAccessoryViewControllers
//            .compactMap {
//                $0.view as? NSVisualEffectView
//            }
//            .forEach {
//                $0.material = .sheet
//            }
//    }
//
//    func windowDidExitFullScreen(_: Notification) {
//        titlebarAccessoryViewControllers
//            .compactMap {
//                $0.view as? NSVisualEffectView
//            }
//            .forEach {
//                $0.material = .menu
//            }
//    }
}
