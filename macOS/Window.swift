import AppKit
import Combine
import Secrets

final class Window: NSWindow, NSWindowDelegate {
    private weak var content: NSView!
    private var subs = Set<AnyCancellable>()
    
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
        
        let selected = CurrentValueSubject<Secret?, Never>(nil)
        
        let bar = Bar(selected: selected)
        
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
        
        let sidebar = Sidebar(toggle: bar.sidebar, selected: selected)
        base.addSubview(sidebar)
        
        content.topAnchor.constraint(equalTo: base.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        content.rightAnchor.constraint(equalTo: base.safeAreaLayoutGuide.rightAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: base.safeAreaLayoutGuide.bottomAnchor).isActive = true
        let left = content.leftAnchor.constraint(equalTo: sidebar.rightAnchor)
        left.isActive = true
        
        sidebar.topAnchor.constraint(equalTo: base.safeAreaLayoutGuide.topAnchor).isActive = true
        sidebar.leftAnchor.constraint(equalTo: base.safeAreaLayoutGuide.leftAnchor).isActive = true
        sidebar.bottomAnchor.constraint(equalTo: base.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        bar
            .sidebar
            .sink {
                left.constant = $0 ? 20 : 40
            }
            .store(in: &subs)
        
        selected
            .sink { [weak self] in
                if let secret = $0 {
                    self?.set(view: Reveal(secret: secret))
                } else {
                    self?.set(view: Landing())
                }
            }
            .store(in: &subs)
    }
    
    override func close() {
        super.close()
        NSApp.terminate(nil)
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
