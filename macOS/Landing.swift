import AppKit

final class Landing: NSView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let new = Option(title: "New secret", symbol: "plus")
        addSubview(new)
        
        let preferences = Option(title: "Preferences", symbol: "gear")
        addSubview(preferences)
        
        let capacity = Option(title: "Capacity", symbol: "lock.square.stack")
        addSubview(capacity)
        
        new.topAnchor.constraint(equalTo: topAnchor).isActive = true
        new.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        preferences.topAnchor.constraint(equalTo: new.bottomAnchor, constant: 25).isActive = true
        preferences.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        capacity.topAnchor.constraint(equalTo: preferences.bottomAnchor, constant: 25).isActive = true
        capacity.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    }
}
