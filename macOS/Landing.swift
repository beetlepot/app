import AppKit
import Combine

final class Landing: NSView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let image = Image(icon: "ladybug.fill")
        image.symbolConfiguration = .init(pointSize: 50, weight: .thin)
            .applying(.init(hierarchicalColor: .tertiaryLabelColor))
        addSubview(image)

        let option = Option(title: "New secret")
        option
            .click
            .sink { [weak self] in
                (self?.window as? Window)?.newSecret()
            }
            .store(in: &subs)
        addSubview(option)

        image.bottomAnchor.constraint(equalTo: centerYAnchor).isActive = true
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        option.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        option.topAnchor.constraint(equalTo: centerYAnchor, constant: 30).isActive = true
    }
    
    override var allowsVibrancy: Bool {
        true
    }
}
