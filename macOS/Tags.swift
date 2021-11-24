import AppKit
import Combine

final class Tags: NSPopover {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(id: Int) {
        super.init()
        behavior = .semitransient
        contentSize = .zero
        contentViewController = .init()
        
        let view = NSView(frame: .init(origin: .zero, size: .init(width: List.width + 2, height: 300)))
        contentViewController!.view = view
        
        let title = Text(vibrancy: true)
        title.stringValue = "Tags"
        title.font = .preferredFont(forTextStyle: .title2)
        title.textColor = .secondaryLabelColor
        view.addSubview(title)
        
        let separator = Separator(mode: .horizontal)
        separator.isHidden = true
        view.addSubview(separator)
        
        let list = List(id: id)
        view.addSubview(list)
        
        title.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        
        separator.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        separator.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        separator.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        list.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        list.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 1).isActive = true
        list.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -1).isActive = true
        list.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -1).isActive = true
        
        NotificationCenter
            .default
            .publisher(for: NSView.boundsDidChangeNotification)
            .compactMap {
                $0.object as? NSClipView
            }
            .filter {
                $0 == list.contentView
            }
            .map {
                $0.bounds.minY < 20
            }
            .removeDuplicates()
            .sink {
                separator.isHidden = $0
            }
            .store(in: &subs)
    }
}
