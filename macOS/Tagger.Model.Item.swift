import AppKit

extension Tagger.Model {
    struct Item: Equatable {
        let string: NSAttributedString
        let frame: CGRect
    }
}
