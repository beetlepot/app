import AppKit

extension NSApplication {
    var activeWindow: Window? {
        keyWindow as? Window ?? anyWindow()
    }
    
    func anyWindow<T>() -> T? {
        windows
            .compactMap {
                $0 as? T
            }
            .first
    }
    
    @objc func show() {
        activeWindow?
            .orderFrontRegardless()
    }
    
    @objc func showPreferencesWindow(_ sender: Any?) {
//        (anyWindow() ?? Preferences())
//            .makeKeyAndOrderFront(nil)
    }
}
