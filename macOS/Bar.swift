import AppKit
import Combine
import Secrets

final class Bar: NSVisualEffectView {
    let sidebar: CurrentValueSubject<Bool, Never>
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init() {
        sidebar = .init(Defaults.sidebar)
        
        super.init(frame: .zero)
        state = .active
        material = .menu
        
        let sidebar = Option(icon: "sidebar.squares.leading", animatable: true)
        sidebar
            .click
            .sink { [weak self] in
                Defaults.sidebar.toggle()
                self?.sidebar.send(Defaults.sidebar)
            }
            .store(in: &subs)
        addSubview(sidebar)
        
        sidebar.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        let left = sidebar.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor)
        left.isActive = true
        
        var animate = false
        
        self
            .sidebar
            .sink { [weak self] in
                if $0 {
                    sidebar.toolTip = "Hide sidebar"
                    left.constant = 100
                } else {
                    sidebar.toolTip = "Show sidebar"
                    left.constant = 10
                }
                
                if animate {
                    NSAnimationContext
                        .runAnimationGroup {
                            $0.allowsImplicitAnimation = true
                            $0.duration = 0.35
                            $0.timingFunction = .init(name: .easeInEaseOut)
                            self?.layoutSubtreeIfNeeded()
                        }
                }
                
                animate = true
            }
            .store(in: &subs)
    }
}
