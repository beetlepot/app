import AppKit
import Secrets

extension Tags {
    struct Info: CollectionItemInfo {
        let id: Tag
        let text: NSAttributedString
        let active: Bool
        let first: Bool
        
        init(tag: Tag, active: Bool, first: Bool) {
            id = tag
            text = .make("\(tag)", attributes: [
                .font: NSFont.preferredFont(forTextStyle: .body),
                .foregroundColor: NSColor.secondaryLabelColor])
            self.active = active
            self.first = first
        }
    }
}
