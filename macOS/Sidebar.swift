import AppKit
import Combine

final class Sidebar: NSView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(toggle: CurrentValueSubject<Bool, Never>) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let width = widthAnchor.constraint(equalToConstant: 0)
        width.isActive = true
        
        toggle
            .sink { [weak self] in
                width.constant = $0 ? 160 : 0
                
                NSAnimationContext
                    .runAnimationGroup {
                        $0.allowsImplicitAnimation = true
                        $0.duration = 0.35
                        $0.timingFunction = .init(name: .easeInEaseOut)
                        self?.superview?.layoutSubtreeIfNeeded()
                    }
            }
            .store(in: &subs)
    }
}
