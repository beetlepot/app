import AppKit
import Combine
import UserNotifications

final class Share: NSPopover {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(id: Int, origin: NSView) {
        super.init()
        behavior = .semitransient
        contentSize = .zero
        contentViewController = .init()
        
        let view = NSView(frame: .init(origin: .zero, size: .init(width: 50, height: 100)))
        contentViewController!.view = view
        
        let services = Option(title: "Services", image: "paperplane")
        services
            .click
            .sink { [weak self] in
                self?.close()
                
                Task {
                    let payload = await cloud.model[id].payload
                    NSSharingServicePicker(items: [payload])
                        .show(relativeTo: origin.bounds, of: origin, preferredEdge: .maxX)
                }
            }
            .store(in: &subs)
        
        let copy = Option(title: "Copy", image: "doc.on.doc")
        copy
            .click
            .sink { [weak self] in
                self?.close()
                
                Task {
                    let payload = await cloud.model[id].payload
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(payload, forType: .string)
                    await UNUserNotificationCenter.send(message: "Secret copied")
                }
            }
            .store(in: &subs)
        
        let stack = NSStackView(views: [services, copy])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .vertical
        view.addSubview(stack)
        
        stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -18).isActive = true
    }
}
