import AppKit
import StoreKit
import Secrets

final class Menu: NSMenu, NSMenuDelegate {
    required init(coder: NSCoder) { super.init(coder: coder) }
    init() {
        super.init(title: "")
        items = [app, file, edit, view, window, help]
    }
    
    private var app: NSMenuItem {
        .parent("Beetle", [
            .child("About", #selector(NSApplication.orderFrontStandardAboutPanel(_:))),
            .separator(),
            .child("Preferences...", #selector(NSApplication.showPreferencesWindow), ","),
            .separator(),
            .child("Capacity", #selector(NSApp.showCapacity)),
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
        .parent("File", [
            .child("New secret", #selector(Window.newSecret), "n")])
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
        var items: [NSMenuItem] = []
        items.append(.child(Defaults.sidebar ? "Hide sidebar" : "Show sidebar", #selector(Window.toggleSidebar)))
        items += [
            .separator(),
            .child("Full Screen", #selector(Window.toggleFullScreen), "f") {
                $0.keyEquivalentModifierMask = [.function]
            }]
        return items
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
                case is Capacity:
                    title = "Capacity"
                case is Preferences:
                    title = "Preferences"
                case is About:
                    title = "About"
                case is Info.Terms:
                    title = "Terms"
                case is Info.Policy:
                    title = "Privacy policy"
                case is Info.Markdown:
                    title = "Markdown"
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
            .child("Markdown", #selector(triggerMarkdown)) {
                $0.target = self
            },
            .separator(),
            .child("Privacy policy", #selector(triggerPolicy)) {
                $0.target = self
            },
            .child("Terms and conditions", #selector(triggerTerms)) {
                $0.target = self
            },
            .separator(),
            .child("Rate on the App Store", #selector(triggerRate)) {
                $0.target = self
            },
            .child("Visit website", #selector(triggerWebsite)) {
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
        SKStoreReviewController.requestReview()
        Defaults.hasRated = true
    }
    
    @objc private func triggerWebsite() {
        NSWorkspace.shared.open(URL(string: "https://beetlepot.github.io/about")!)
    }
    
    @objc private func triggerMarkdown() {
        (NSApp.anyWindow() ?? Info.Markdown())
            .makeKeyAndOrderFront(nil)
    }
    
    @objc private func triggerPolicy() {
        (NSApp.anyWindow() ?? Info.Policy())
            .makeKeyAndOrderFront(nil)
    }
    
    @objc private func triggerTerms() {
        (NSApp.anyWindow() ?? Info.Terms())
            .makeKeyAndOrderFront(nil)
    }
}
