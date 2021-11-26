import AppKit
import UserNotifications
import Combine
import Secrets

final class Window: NSWindow, NSWindowDelegate {
    private var subs = Set<AnyCancellable>()
    let toggle = CurrentValueSubject<Bool, Never>(Defaults.sidebar)
    
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
        setFrameAutosaveName("Window")
        titlebarAppearsTransparent = true
        delegate = self
        
        let selected = CurrentValueSubject<Int?, Never>(nil)
        
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
                
                if let id = $0 {
                    view = Reveal(id: id)
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
        
        Task {
//            await cloud.add(purchase: .ten)
//            try! await cloud.secret()
//            try! await cloud.secret()
//            try! await cloud.secret()
//            try! await cloud.secret()
//            try! await cloud.secret()
//            await cloud.update(id: 0, name: "Gran's secret Shortbread Recipe")
//            await cloud.update(id: 0, payload: """
//            **Ingredients**
//            — 200g _butter_
//            — 100g _caster sugar_
//            — 300g _plain flour_
//            — 1 level teaspoon _baking powder_
//            — 1 level teaspoon _ginger_
//            — 1 pinch _salt_
//
//            **Process**
//            _1._ Cream butter and sugar.
//            _2._ Sift in other ingredients and mix well.
//            _3._ Spread in lined bake tray.
//            _4._ Bake in moderate over circa 40 minutes until golden.
//            _5._ Eat warm.
//
//            """)
//            await cloud.add(id: 0, tag: .biscuits)
//            await cloud.add(id: 0, tag: .cook)
//            await cloud.add(id: 0, tag: .family)
//            await cloud.add(id: 0, tag: .food)
//
//            await cloud.add(id: 1, tag: .hidden)
//            await cloud.add(id: 1, tag: .keys)
//
//            await cloud.add(id: 2, tag: .important)
//
//            await cloud.update(id: 0, favourite: true)
//            await cloud.update(id: 2, favourite: true)
//
//            await cloud.update(id: 1, name: "Office's door keycode")
//            await cloud.update(id: 2, name: "The meaning of life")
//            await cloud.update(id: 3, name: "Cezz's phone number")
//            await cloud.update(id: 4, name: "The secret cookie stash")
        }
    }
    
    override func close() {
        super.close()
        NSApp.terminate(nil)
    }
    
    func edit(id: Int) {
        key(child: Edit(id: id))
    }
    
    @objc func newSecret() {
        Task {
            do {
                try await edit(id: cloud.secret())
                await UNUserNotificationCenter.send(message: "Created a new secret!")
            } catch {
                key(child: Full())
            }
        }
    }
    
    @objc func toggleSidebar() {
        Defaults.sidebar.toggle()
        toggle.send(Defaults.sidebar)
    }
    
    private func key(child: NSWindow) {
        addChildWindow(child, ordered: .above)
        child.makeKey()
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
