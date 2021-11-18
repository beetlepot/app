import AppKit

extension Sidebar {
    struct Info: CollectionItemInfo {
        let id: Int
        let text: NSAttributedString
        
        init(id: Int) {
            self.id = id
            text = .init(string: "")
        }
    }
}
