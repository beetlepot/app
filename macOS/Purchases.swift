import AppKit
import Combine

final class Purchases: NSWindow {
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 500, height: 400),
                   styleMask: [.closable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        animationBehavior = .alertPanel
        toolbar = .init()
        isReleasedWhenClosed = false
        titlebarAppearsTransparent = true
        center()
        
        let content = NSVisualEffectView()
        content.state = .active
        content.material = .menu
        contentView = content
        
        let vibrant = Vibrant(layer: false)
        vibrant.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(vibrant)
        
        let title = Text(vibrancy: true)
        title.stringValue = "Purchases"
        title.font = .preferredFont(forTextStyle: .title3)
        title.textColor = .tertiaryLabelColor
        vibrant.addSubview(title)
        
        let icon = Image(icon: "cart")
        icon.symbolConfiguration = .init(textStyle: .title3)
            .applying(.init(hierarchicalColor: .tertiaryLabelColor))
        vibrant.addSubview(icon)
        
        vibrant.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
        vibrant.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -26).isActive = true
        vibrant.heightAnchor.constraint(equalToConstant: 52).isActive = true
        vibrant.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        title.centerYAnchor.constraint(equalTo: vibrant.centerYAnchor).isActive = true
        title.rightAnchor.constraint(equalTo: icon.leftAnchor, constant: -10).isActive = true
        
        icon.rightAnchor.constraint(equalTo: vibrant.rightAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: vibrant.centerYAnchor).isActive = true
        
        var inner: NSView?
        
        store
            .status
            .sink { [weak self] status in
                inner?.removeFromSuperview()

                switch status {
                case .loading:
                    inner = NSView()
                    
                    let image = Image(icon: "hourglass")
                    image.symbolConfiguration = .init(textStyle: .largeTitle)
                        .applying(.init(hierarchicalColor: .controlAccentColor))
                    inner!.addSubview(image)
                    
                    image.centerXAnchor.constraint(equalTo: inner!.centerXAnchor).isActive = true
                    image.centerYAnchor.constraint(equalTo: inner!.centerYAnchor).isActive = true
                case let .error(error):
                    inner = self?.message(error: error)
                case let .products(products):
//                    if let product = products.first {
//                        inner = Item(product: product)
//                    } else {
                        inner = self?.message(error: "")
//                    }
                }
                
                inner!.translatesAutoresizingMaskIntoConstraints = false
                content.addSubview(inner!)
                
                inner!.topAnchor.constraint(equalTo: content.topAnchor, constant: -20).isActive = true
                inner!.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
                inner!.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
                inner!.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -30).isActive = true
            }
            .store(in: &subs)
        
//        Task {
//            await store.load()
//        }
    }
    
    private func message(error: String) -> NSView {
        let inner = NSView()
        
        let text = Text(vibrancy: true)
        text.font = .preferredFont(forTextStyle: .title3)
        text.alignment = .center
        text.textColor = .secondaryLabelColor
        text.stringValue = error
        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        inner.addSubview(text)
        
        text.centerXAnchor.constraint(equalTo: inner.centerXAnchor).isActive = true
        text.centerYAnchor.constraint(equalTo: inner.centerYAnchor).isActive = true
        text.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        return inner
    }
}
