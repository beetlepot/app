import AppKit
import Secrets

final class Textview: NSTextView {
    override var canBecomeKeyView: Bool {
        true
    }

    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .init(x: 0, y: 0, width: 0, height: 100_000), textContainer: Container())
        allowsUndo = true
        isRichText = false
        drawsBackground = false
        isContinuousSpellCheckingEnabled = Defaults.spell
        isAutomaticTextCompletionEnabled = Defaults.correction
        insertionPointColor = .labelColor
        typingAttributes[.font] = NSFont.monospacedSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .title2).pointSize, weight: .regular)
        typingAttributes[.kern] = 0.5
        font = typingAttributes[.font] as? NSFont
        selectedTextAttributes[.backgroundColor] = NSColor.tertiaryLabelColor
        isVerticallyResizable = true
        isHorizontallyResizable = true
        textContainerInset.width = 20
        textContainerInset.height = 20
    }
    
    override func cancelOperation(_ sender: Any?) {
        window?.makeFirstResponder(nil)
    }
    
    override func drawInsertionPoint(in rect: NSRect, color: NSColor, turnedOn: Bool) {
        var rect = rect
        rect.size.width = 2
        super.drawInsertionPoint(in: rect, color: color, turnedOn: turnedOn)
    }
    
    override func setNeedsDisplay(_ rect: NSRect, avoidAdditionalLayout: Bool) {
        var rect = rect
        rect.size.width += 1
        super.setNeedsDisplay(rect, avoidAdditionalLayout: avoidAdditionalLayout)
    }
    
    override func didChangeText() {
        super.didChangeText()
        layoutManager!.ensureLayout(for: textContainer!)
    }
    
//    override func keyDown(with: NSEvent) {
//        switch with.keyCode {
//        case 36:
//            if with.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command {
//                switch session.state.value {
//                case .create, .column, .card:
//                    session.add()
//                case .edit:
//                    session.save()
//                default:
//                    break
//                }
//            } else {
//                super.keyDown(with: with)
//            }
//        default: super.keyDown(with: with)
//        }
//    }
    
    override var allowsVibrancy: Bool {
        true
    }
    
    override func viewDidMoveToWindow() {
        window?.initialFirstResponder = self
    }
}
