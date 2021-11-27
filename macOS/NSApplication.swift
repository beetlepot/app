import AppKit

extension NSApplication {    
    @objc func showPurchases() {
        (NSApp.anyWindow() ?? Purchases())
            .makeKeyAndOrderFront(nil)
    }
    
    @objc func showCapacity() {
        (NSApp.anyWindow() ?? Capacity())
            .makeKeyAndOrderFront(nil)
    }
    
    @objc func showPreferencesWindow(_ sender: Any?) {
        (anyWindow() ?? Preferences())
            .makeKeyAndOrderFront(nil)
    }
    
    func anyWindow<T>() -> T? {
        windows
            .compactMap {
                $0 as? T
            }
            .first
    }
}
