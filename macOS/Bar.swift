import AppKit
import Combine
import Secrets

final class Bar: NSVisualEffectView {
    let sidebar: CurrentValueSubject<Bool, Never>
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(selected: CurrentValueSubject<Secret?, Never>) {
        sidebar = .init(Defaults.sidebar)
        
        super.init(frame: .zero)
        state = .active
        material = .menu
        
        let sidebar = Option(icon: "sidebar.squares.leading")
        sidebar
            .click
            .sink { [weak self] in
                Defaults.sidebar.toggle()
                self?.sidebar.send(Defaults.sidebar)
            }
            .store(in: &subs)
        addSubview(sidebar)
        
        let edit = Option(icon: "pencil.circle.fill", size: 22)
        edit
            .click
            .sink {
                
            }
            .store(in: &subs)
        
        let ellipsis = Option(icon: "ellipsis", size: 18)
        ellipsis
            .click
            .sink {
                
            }
            .store(in: &subs)
        
        let share = Option(icon: "square.and.arrow.up")
        share
            .click
            .sink {
                
            }
            .store(in: &subs)
        
        let stack = NSStackView(views: [ellipsis, share, edit])
        addSubview(stack)
        
        sidebar.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sidebar.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        
        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        stack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        self
            .sidebar
            .sink {
                if $0 {
                    sidebar.toolTip = "Hide sidebar"
                } else {
                    sidebar.toolTip = "Show sidebar"
                }
            }
            .store(in: &subs)
    }
}
