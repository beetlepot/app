import AppKit
import Combine
import Secrets

extension Sidebar {
    final class Filters: NSView {
        let state = CurrentValueSubject<Filter, Never>(.init())
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let activate = Option(icon: "line.3.horizontal.decrease.circle", size: 20)
            
            let deactivate = Active(icon: "line.3.horizontal.decrease.circle.fill")
            deactivate.state = .hidden
            
            let tags = Option(icon: "tag", size: 15)
            tags.state = .hidden
            
            let search = Edit.Field()
            
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
                .sink {
                    activate.state = .hidden
                    deactivate.state = .on
                    tags.state = .on
                    
                    stack.animator().insertView(search, at: 0, in: .leading)
                }
                .store(in: &subs)
            
            deactivate
                .click
                .sink {
                    activate.state = .on
                    deactivate.state = .hidden
                    tags.state = .hidden
//                    search.isHidden = true
                    
                    stack.animator().removeView(search)
                }
                .store(in: &subs)
            
            widthAnchor.constraint(equalToConstant: 200).isActive = true
            bottomAnchor.constraint(equalTo: stack.bottomAnchor).isActive = true
            
            stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
            stack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            stack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        }
    }
}
