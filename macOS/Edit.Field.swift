import AppKit

extension Edit {
    final class Field: NSTextField {        
        required init?(coder: NSCoder) { nil }
        init() {
            Self.cellClass = Cell.self
            super.init(frame: .zero)
            bezelStyle = .roundedBezel
            translatesAutoresizingMaskIntoConstraints = false
            font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title1).pointSize, weight: .regular)
            controlSize = .large
            lineBreakMode = .byTruncatingTail
            textColor = .labelColor
            isAutomaticTextCompletionEnabled = false
            placeholderString = "Title"
        }
        
        deinit {
            NSApp
                .windows
                .forEach {
                    $0.undoManager?.removeAllActions()
                }
        }
        
        override var canBecomeKeyView: Bool {
            true
        }
        
        override func cancelOperation(_: Any?) {
            window?.makeFirstResponder(nil)
        }
        
        override func becomeFirstResponder() -> Bool {
            undoManager?.removeAllActions()
            return super.becomeFirstResponder()
        }
    }
}
