import AppKit
import Combine
import UserNotifications
import Secrets

final class Bar: NSVisualEffectView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(toggle: CurrentValueSubject<Bool, Never>, selected: CurrentValueSubject<Int?, Never>) {
        super.init(frame: .zero)
        state = .active
        material = .menu
        
        let change = PassthroughSubject<Tag, Never>()
        
        let sidebar = Option(icon: "sidebar.squares.leading", size: 15)
        sidebar
            .click
            .sink {
                Defaults.sidebar.toggle()
                toggle.send(Defaults.sidebar)
            }
            .store(in: &subs)
        
        let plus = Option(icon: "plus", size: 15)
        plus.toolTip = "New secret"
        plus
            .click
            .sink { [weak self] in
                (self?.window as? Window)?.newSecret()
            }
            .store(in: &subs)
        
        let edit = Option(icon: "pencil.circle", size: 17)
        edit.toolTip = "Edit secret"
        edit
            .click
            .sink { [weak self] in
                guard let id = selected.value else { return }
                (self?.window as? Window)?.edit(id: id)
            }
            .store(in: &subs)
        
        let share = Option(icon: "square.and.arrow.up", size: 15)
        share.toolTip = "Share secret"
        share
            .click
            .sink {
                guard let id = selected.value else { return }
                let pop = Share(id: id, origin: share)
                pop.show(relativeTo: share.bounds, of: share, preferredEdge: .maxY)
                pop.contentViewController!.view.window!.makeKey()
            }
            .store(in: &subs)
        
        let favourite = Option(icon: "heart", size: 16, color: .tertiaryLabelColor)
        favourite.toolTip = "Make favourite"
        favourite
            .click
            .sink {
                guard let id = selected.value else { return }
                Task
                    .detached(priority: .utility) {
                        await cloud.update(id: id, favourite: true)
                    }
            }
            .store(in: &subs)
        
        let unfavourite = Option(icon: "heart.fill", size: 16, color: .labelColor)
        unfavourite.toolTip = "Remove favourite"
        unfavourite
            .click
            .sink {
                guard let id = selected.value else { return }
                Task
                    .detached(priority: .utility) {
                        await cloud.update(id: id, favourite: false)
                    }
            }
            .store(in: &subs)
        
        let tags = Option(icon: "tag", size: 14)
        tags.toolTip = "Edit tags"
        tags
            .click
            .sink {
                guard let id = selected.value else { return }
                let pop = Tags(id: id, change: change)
                pop.show(relativeTo: tags.bounds, of: tags, preferredEdge: .maxY)
                pop.contentViewController!.view.window!.makeKey()
            }
            .store(in: &subs)
        
        let delete = Option(icon: "trash", size: 14)
        delete.toolTip = "Delete secret"
        delete
            .click
            .sink {
                guard let id = selected.value else { return }
                
                let alert = NSAlert()
                alert.alertStyle = .warning
                alert.icon = .init(systemSymbolName: "trash", accessibilityDescription: nil)
                alert.messageText = "Delete secret?"
                
                Task {
                    let name = await cloud.model[id].name
                    alert.informativeText = name
                }
                
                let delete = alert.addButton(withTitle: "Delete")
                let cancel = alert.addButton(withTitle: "Cancel")
                delete.keyEquivalent = "\r"
                cancel.keyEquivalent = "\u{1b}"
                if alert.runModal().rawValue == delete.tag {
                    Task {
                        selected.send(nil)
                        await cloud.delete(id: id)
                        await UNUserNotificationCenter.send(message: "Deleted secret!")
                    }
                }
            }
            .store(in: &subs)
        
        change
            .sink { tag in
                guard let id = selected.value else { return }
                
                Task
                    .detached {
                        if await cloud.model[id].tags.contains(tag) {
                            await cloud.remove(id: id, tag: tag)
                        } else {
                            await cloud.add(id: id, tag: tag)
                        }
                    }
            }
            .store(in: &subs)
        
        let left = NSStackView(views: [sidebar, plus])
        addSubview(left)
        
        let right = NSStackView(views: [delete, tags, edit, share, unfavourite, favourite])
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
        
        cloud
            .combineLatest(selected
                            .compactMap { $0 })
            .map {
                $0[$1].favourite
            }
            .removeDuplicates()
            .sink {
                favourite.isHidden = $0
                unfavourite.isHidden = !$0
            }
            .store(in: &subs)
    }
}
