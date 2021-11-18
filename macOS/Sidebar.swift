import AppKit

final class Sidebar: NSView {
    var visible: Bool = false {
        didSet {
            width.constant = visible ? List.width : 0
        }
    }
    
    private weak var width: NSLayoutConstraint!
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        width = widthAnchor.constraint(equalToConstant: 0)
        width.isActive = true
    }
}
