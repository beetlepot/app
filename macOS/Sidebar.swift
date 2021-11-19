import AppKit
import Combine
import Secrets

final class Sidebar: NSView {
    private var subs = Set<AnyCancellable>()
    private var items = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(toggle: CurrentValueSubject<Bool, Never>, selected: CurrentValueSubject<Secret?, Never>) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let size = CGFloat(200)
        let filters = CurrentValueSubject<Filter, Never>(.init())
        
        let flip = Flip()
        flip.translatesAutoresizingMaskIntoConstraints = false
        
        let scroll = NSScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.documentView = flip
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        scroll.drawsBackground = false
        addSubview(scroll)
        
        let stack = NSStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .vertical
        flip.addSubview(stack)
        
        let width = widthAnchor.constraint(equalToConstant: 0)
        width.isActive = true
        
        scroll.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        flip.topAnchor.constraint(equalTo: scroll.topAnchor).isActive = true
        flip.leftAnchor.constraint(equalTo: scroll.leftAnchor).isActive = true
        flip.rightAnchor.constraint(equalTo: scroll.rightAnchor).isActive = true
        flip.bottomAnchor.constraint(greaterThanOrEqualTo: scroll.bottomAnchor).isActive = true
        
        stack.topAnchor.constraint(equalTo: flip.topAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: flip.leftAnchor, constant: 10).isActive = true
        stack.widthAnchor.constraint(equalToConstant: size - 10).isActive = true
        stack.bottomAnchor.constraint(equalTo: flip.bottomAnchor).isActive = true
        
        toggle
            .sink { [weak self] in
                width.constant = $0 ? size : 0
                
                NSAnimationContext
                    .runAnimationGroup {
                        $0.allowsImplicitAnimation = true
                        $0.duration = 0.3
                        $0.timingFunction = .init(name: .easeInEaseOut)
                        self?.superview?.layoutSubtreeIfNeeded()
                    }
            }
            .store(in: &subs)
        
        cloud
            .combineLatest(filters)
            .map {
                $0.filtering(with: $1)
            }
            .removeDuplicates()
            .combineLatest(selected
                            .map { _ in })
            .sink { [weak self] secrets, _ in
                stack.setViews(self?.items(secrets: secrets, selected: selected) ?? [], in: .top)
            }
            .store(in: &subs)
    }
    
    private func items(secrets: [Secret], selected: CurrentValueSubject<Secret?, Never>) -> [Item] {
        items = []
        
        return secrets
            .map { secret in
                let item = Item(secret: secret)
                item.state = secret.id == selected.value?.id ? .selected : .on
                item
                    .click
                    .sink {
                        selected.send(secret)
                    }
                    .store(in: &items)
                return item
            }
    }
}
