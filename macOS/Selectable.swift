import AppKit

final class Selectable: NSTextField {
    private let vibrancy: Bool
    
    required init?(coder: NSCoder) { nil }
    init(vibrancy: Bool) {
        self.vibrancy = vibrancy
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        isBezeled = false
        isEditable = false
        allowsEditingTextAttributes = true
        isSelectable = true
        setAccessibilityRole(.staticText)
    }
    
    override var acceptsFirstResponder: Bool {
        false
    }
    
    override var canBecomeKeyView: Bool {
        false
    }
    
    override var allowsVibrancy: Bool {
        vibrancy
    }
    
    override func acceptsFirstMouse(for: NSEvent?) -> Bool {
        false
    }
}
