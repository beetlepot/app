import AppKit
import StoreKit
import Secrets

final class Menu: NSMenu, NSMenuDelegate {
    private let shortcut = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    required init(coder: NSCoder) { super.init(coder: coder) }
    init() {
        super.init(title: "")
        items = [app, file, edit, view, window, help]
        shortcut.button!.image = NSImage(named: "status")
        shortcut.button!.target = self
        shortcut.button!.action = #selector(triggerShortcut)
        shortcut.button!.menu = .init()
        shortcut.button!.sendAction(on: [.leftMouseUp, .rightMouseUp])
        shortcut.button!.menu!.items = [
            .child("Show Beetle", #selector(NSApplication.show)),
            .separator(),
            .child("Quit Beetle", #selector(NSApplication.terminate))]
    }
    
    private var app: NSMenuItem {
        .parent("Beetle", [
            .child("About", #selector(NSApplication.orderFrontStandardAboutPanel(_:))),
            .separator(),
            .child("Preferences...", #selector(NSApplication.showPreferencesWindow), ","),
            .separator(),
            .child("In-App Purchases", #selector(NSApp.showPurchases)),
            .separator(),
            .child("Hide", #selector(NSApplication.hide), "h"),
            .child("Hide Others", #selector(NSApplication.hideOtherApplications), "h") {
                $0.keyEquivalentModifierMask = [.option, .command]
            },
            .child("Show all", #selector(NSApplication.unhideAllApplications)),
            .separator(),
            .child("Quit", #selector(NSApplication.terminate), "q")])
    }
    
    private var file: NSMenuItem {
        .parent("File", [])
    }
    
    private var edit: NSMenuItem {
        .parent("Edit", [
            .child("Undo", Selector(("undo:")), "z"),
            .child("Redo", Selector(("redo:")), "Z"),
            .separator(),
            .child("Cut", #selector(NSText.cut), "x"),
            .child("Copy", #selector(NSText.copy(_:)), "c"),
            .child("Paste", #selector(NSText.paste), "v"),
            .child("Delete", #selector(NSText.delete)),
            .child("Select All", #selector(NSText.selectAll), "a")])
    }
    
    private var view: NSMenuItem {
        .parent("View", viewItems) {
            $0.submenu!.delegate = self
        }
    }
    
    private var viewItems: [NSMenuItem] {
//        var web: Web?
//
//        if let window = NSApp.keyWindow as? Window,
//           case let .web(item) = window.status.item.flow {
//            web = item
//        }
//
        return [
            .separator(),
            .child("Full Screen", #selector(Window.toggleFullScreen), "f") {
                $0.keyEquivalentModifierMask = [.function]
            }]
    }
    
    private var window: NSMenuItem {
        .parent("Window", windowItems) {
            $0.submenu!.delegate = self
        }
    }
    
    private var windowItems: [NSMenuItem] {
        var items: [NSMenuItem] = [
            .child("Minimize", #selector(NSWindow.miniaturize), "m"),
            .child("Zoom", #selector(NSWindow.zoom)),
            .separator(),
            .child("Close", #selector(NSWindow.close), "w"),
            .separator(),
            .child("Bring All to Front", #selector(NSApplication.arrangeInFront)),
            .separator()]

        items += NSApp
            .windows
            .compactMap { item in
                
                var title = ""
                var add: NSWindow? = item
                
                switch item {
                case is Window:
                    title = "Beetle"
                case is Purchases:
                    title = "In-App Purchases"
                default:
                    add = nil
                }
                
                return add
                    .map {
                        .child(title, #selector($0.makeKeyAndOrderFront)) {
                            $0.target = item
                            $0.state = NSApp.mainWindow == item ? .on : .off
                        }
                    }
            }
        
        return items
    }
    
    private var help: NSMenuItem {
        .parent("Help", [
            .child("Policy", #selector(triggerPolicy)) {
                $0.target = self
            },
            .child("Terms and conditions", #selector(triggerTerms)) {
                $0.target = self
            },
            .separator(),
            .child("Rate on the App Store", #selector(triggerRate)) {
                $0.target = self
            },
            .child("Visit goprivacy.app", #selector(triggerWebsite)) {
                $0.target = self
            }])
    }
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        switch menu.title {
        case "View":
            menu.items = viewItems
        case "Window":
            menu.items = windowItems
        default:
            break
        }
    }
    
    @objc private func triggerRate() {
//        SKStoreReviewController.requestReview()
//        Defaults.hasRated = true
    }
    
    @objc private func triggerWebsite() {
//        NSApp.open(url: URL(string: "https://goprivacy.app")!)
    }
    
    @objc private func triggerPolicy() {
//        (NSApp.anyWindow() ?? Info.Policy())
//            .makeKeyAndOrderFront(nil)
    }
    
    @objc private func triggerTerms() {
//        (NSApp.anyWindow() ?? Info.Terms())
//            .makeKeyAndOrderFront(nil)
    }
    
    @objc private func triggerShortcut(_ button: NSStatusBarButton) {
//        guard let event = NSApp.currentEvent else { return }
//
//        switch event.type {
//        case .rightMouseUp:
//            NSMenu.popUpContextMenu(button.menu!, with: event, for: button)
//        case .leftMouseUp:
//            let shortcut = Shortcut(origin: button)
//            shortcut.contentViewController!.view.window!.makeKey()
//        default:
//            break
//        }
    }
}
