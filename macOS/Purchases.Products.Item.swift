import AppKit
import StoreKit
import Combine
import Secrets

extension Purchases.Products {
    final class Item: NSView {
        var product: Product? {
            didSet {
                guard let product = product else { return }
                
                image.image = .init(named: product.id)
                
                info.attributedStringValue = .make(alignment: .center, spacing: 2) {
                    $0.append(.make(product.displayName, attributes: [
                        .foregroundColor: NSColor.labelColor,
                        .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .largeTitle).pointSize, weight: .regular)]))
                    $0.newLine()
                    $0.append(.make(product.description, attributes: [
                        .foregroundColor: NSColor.secondaryLabelColor,
                        .font: NSFont.preferredFont(forTextStyle: .callout)]))
                    $0.newLine()
                    $0.newLine()
                    $0.newLine()
                    $0.append(.make(product.displayPrice, attributes: [
                        .foregroundColor: NSColor.labelColor,
                        .font: NSFont.monospacedDigitSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .regular)]))
                    
                    if product.id != Purchase.one.rawValue, let percent = Purchase(rawValue: product.id)?.save {
                        $0.newLine()
                        $0.append(.make("— Save " + percent.formatted(.percent) + " —", attributes: [
                            .foregroundColor: NSColor.secondaryLabelColor,
                            .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .callout).pointSize, weight: .light)]))
                    }
                }
            }
        }
        
        private weak var image: Image!
        private weak var info: Text!
        private weak var save: Text!
        private var sub: AnyCancellable?
        
        required init?(coder: NSCoder) { return nil }
        init() {
            super.init(frame: .zero)
            let image = Image()
            self.image = image
            addSubview(image)
            
            let info = Text(vibrancy: true)
            self.info = info
            addSubview(info)
            
            let action = Action()
            sub = action
                .click
                .sink { [weak self] in
                    guard let product = self?.product else { return }
                    Task {
                        await store.purchase(product)
                    }
                }
            addSubview(action)
            
            image.topAnchor.constraint(equalTo: topAnchor).isActive = true
            image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            
            info.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
            info.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            info.widthAnchor.constraint(lessThanOrEqualToConstant: 150).isActive = true
            
            action.topAnchor.constraint(equalTo: info.bottomAnchor, constant: 10).isActive = true
            action.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
    }
}
