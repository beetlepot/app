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
        
        let sidebar = Option(icon: "sidebar.squares.leading")
        sidebar
            .click
            .sink { [weak self] in
                Defaults.sidebar.toggle()
                self?.sidebar.send(Defaults.sidebar)
            }
            .store(in: &subs)
        addSubview(sidebar)
        
        sidebar.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sidebar.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        
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
