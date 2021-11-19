import AppKit
import Combine
import Secrets

final class Bar: NSVisualEffectView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(toggle: CurrentValueSubject<Bool, Never>, selected: CurrentValueSubject<Secret?, Never>) {
        super.init(frame: .zero)
        state = .active
        material = .menu
        
        let sidebar = Option(icon: "sidebar.squares.leading", size: 14)
        sidebar
            .click
            .sink {
                Defaults.sidebar.toggle()
                toggle.send(Defaults.sidebar)
            }
            .store(in: &subs)
        
        let plus = Option(icon: "plus", size: 14)
        plus
            .click
            .sink { [weak self] in
                (self?.window as? Window)?.newSecret(nil)
            }
            .store(in: &subs)
        
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
        
        let share = Option(icon: "square.and.arrow.up", size: 13)
        share
            .click
            .sink {
                
            }
            .store(in: &subs)
        
        let left = NSStackView(views: [sidebar, plus])
        addSubview(left)
        
        let right = NSStackView(views: [ellipsis, share, edit])
        addSubview(right)
        
        left.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        left.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        right.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        right.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        toggle
            .sink {
                if $0 {
                    sidebar.toolTip = "Hide sidebar"
                } else {
                    sidebar.toolTip = "Show sidebar"
                }
            }
            .store(in: &subs)
        
        selected
            .map {
                $0 == nil
            }
            .removeDuplicates()
            .sink {
                right.isHidden = $0
            }
            .store(in: &subs)
    }
}
