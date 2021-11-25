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
            
            let change = PassthroughSubject<Tag, Never>()
            
            let activate = Option(icon: "line.3.horizontal.decrease.circle", size: 20)
            
            let deactivate = Active(icon: "line.3.horizontal.decrease.circle.fill")
            deactivate.state = .hidden
            
            let tags = Option(icon: "tag", size: 15)
            tags
                .click
                .sink {
                    let pop = Tags(id: id, change: change)
                    pop.show(relativeTo: tags.bounds, of: tags, preferredEdge: .maxY)
                    pop.contentViewController!.view.window!.makeKey()
                }
                .store(in: &subs)
            tags.state = .hidden
            
            let search = Field()
            search.delegate = self
            self.search = search
            
            let actions = NSStackView(views: [
                activate,
                deactivate,
                tags])
            
            let stack = NSStackView(views: [
                actions])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.orientation = .vertical
            stack.alignment = .leading
            addSubview(stack)
            
            activate
                .click
                .sink { [weak self] in
                    activate.state = .hidden
                    deactivate.state = .on
                    tags.state = .on
                    
                    stack.animator().insertView(search, at: 0, in: .leading)
                    self?.window?.makeFirstResponder(search)
                }
                .store(in: &subs)
            
            deactivate
                .click
                .sink { [weak self] in
                    activate.state = .on
                    deactivate.state = .hidden
                    tags.state = .hidden
                    search.stringValue = ""
                    
                    stack.animator().removeView(search)
                    self?.state.value = .init()
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
