import AppKit
import Combine
import Secrets

extension Sidebar {
    final class Filters: NSView, NSTextFieldDelegate {
        let state = CurrentValueSubject<Filter, Never>(.init())
        private weak var search: Field!
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let active = CurrentValueSubject<Set<Tag>, Never>([])
            let change = PassthroughSubject<Tag, Never>()
            
            let tagger = Tagger()
            
            let activate = Option(icon: "line.3.horizontal.decrease.circle", size: 20)
            
            let deactivate = Active(icon: "line.3.horizontal.decrease.circle.fill", size: 21)
            deactivate.state = .hidden
            
            let favourite = Option(icon: "heart", size: 16)
            favourite.state = .hidden
            
            let unfavourite = Active(icon: "heart.fill", size: 16)
            unfavourite.state = .hidden
            
            let tags = Option(icon: "tag", size: 14)
            tags
                .click
                .sink { [weak self] in
                    guard let filtered = self?.state.value.tags else { return }
                    
                    let pop = Tags(active: active, change: change)
                    pop.show(relativeTo: tags.bounds, of: tags, preferredEdge: .maxY)
                    pop.contentViewController!.view.window!.makeKey()
                    active.send(filtered)
                }
                .store(in: &subs)
            tags.state = .hidden
            
            let search = Field()
            search.delegate = self
            self.search = search
            
            let stack = NSStackView(views: [
                NSStackView(views: [
                    activate,
                    deactivate,
                    favourite,
                    unfavourite,
                    tags])])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.orientation = .vertical
            stack.alignment = .leading
            addSubview(stack)
            
            activate
                .click
                .sink { [weak self] in
                    activate.state = .hidden
                    deactivate.state = .on
                    favourite.state = .on
                    tags.state = .on
                    
                    stack.animator().insertView(tagger, at: 0, in: .leading)
                    stack.animator().insertView(search, at: 0, in: .leading)
                    self?.window?.makeFirstResponder(search)
                }
                .store(in: &subs)
            
            deactivate
                .click
                .sink { [weak self] in
                    activate.state = .on
                    deactivate.state = .hidden
                    favourite.state = .hidden
                    unfavourite.state = .hidden
                    tags.state = .hidden
                    search.stringValue = ""
                    
                    stack.animator().removeView(tagger)
                    stack.animator().removeView(search)
                    self?.state.value = .init()
                }
                .store(in: &subs)
            
            favourite
                .click
                .sink { [weak self] in
                    unfavourite.state = .on
                    favourite.state = .hidden
                    self?.state.value.favourites = true
                }
                .store(in: &subs)
            
            unfavourite
                .click
                .sink { [weak self] in
                    unfavourite.state = .hidden
                    favourite.state = .on
                    self?.state.value.favourites = false
                }
                .store(in: &subs)
            
            change
                .sink { [weak self] tag in
                    if active.value.contains(tag) {
                        active.value.remove(tag)
                        self?.state.value.tags.remove(tag)
                    } else {
                        active.value.insert(tag)
                        self?.state.value.tags.insert(tag)
                    }
                }
                .store(in: &subs)
            
            state
                .map(\.tags)
                .removeDuplicates()
                .sink {
                    tagger.tags.send($0.list)
                }
                .store(in: &subs)
            
            widthAnchor.constraint(equalToConstant: 184).isActive = true
            bottomAnchor.constraint(equalTo: stack.bottomAnchor).isActive = true
            
            stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
            stack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            stack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        }
        
        func controlTextDidChange(_ field: Notification) {
            (field.object as? Field)
                .map {
                    state.value.search = $0.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
                }
        }
        
        func control(_: NSControl, textView: NSTextView, doCommandBy: Selector) -> Bool {
            switch doCommandBy {
            case
                #selector(cancelOperation),
                #selector(complete),
                #selector(NSSavePanel.cancel),
                #selector(insertNewline),
                #selector(moveUp),
                #selector(moveDown),
                #selector(insertTab),
                #selector(insertBacktab):
                window?.makeFirstResponder(nil)
            default:
                return false
            }
            return true
        }
    }
}
