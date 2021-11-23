import AppKit
import UserNotifications
import Combine
import Secrets

final class Window: NSWindow, NSWindowDelegate {
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
        titlebarAppearsTransparent = true
        
        let toggle = CurrentValueSubject<Bool, Never>(Defaults.sidebar)
        let selected = CurrentValueSubject<Secret?, Never>(nil)
        
        let top = NSTitlebarAccessoryViewController()
        top.view = Bar(toggle: toggle, selected: selected)
        top.layoutAttribute = .top
        addTitlebarAccessoryViewController(top)
        
        let base = NSVisualEffectView()
        base.material = .menu
        base.state = .active
        contentView = base
        
        let content = NSView()
        content.translatesAutoresizingMaskIntoConstraints = false
        base.addSubview(content)
        
        let sidebar = Sidebar(toggle: toggle, selected: selected)
        base.addSubview(sidebar)
        
        content.topAnchor.constraint(equalTo: base.topAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: base.rightAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: base.bottomAnchor).isActive = true
        let left = content.leftAnchor.constraint(equalTo: sidebar.rightAnchor)
        left.isActive = true
        
        sidebar.topAnchor.constraint(equalTo: base.topAnchor).isActive = true
        sidebar.leftAnchor.constraint(equalTo: base.safeAreaLayoutGuide.leftAnchor).isActive = true
        sidebar.bottomAnchor.constraint(equalTo: base.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        selected
            .sink {
                let view: NSView
                
                if let secret = $0 {
                    view = Reveal(secret: secret)
                } else {
                    view = Landing()
                }
                
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
            .store(in: &subs)
    }
    
    override func close() {
        super.close()
        NSApp.terminate(nil)
    }
    
    @objc func newSecret() {
        Task {
            do {
                let id = try await cloud.secret()
                addChildWindow(Edit(secret: await cloud.model[id]), ordered: .above)
                await UNUserNotificationCenter.send(message: "Created a new secret!")
            } catch {
                let full = Full()
                addChildWindow(full, ordered: .above)
                full.makeKey()
            }
        }
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