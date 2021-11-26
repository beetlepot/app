import AppKit

extension NSApplication {
    @objc func show() {
        (keyWindow as? Window ?? anyWindow())?
            .orderFrontRegardless()
    }
    
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
    
    private func anyWindow<T>() -> T? {
        windows
            .compactMap {
                $0 as? T
            }
            .first
    }
}
