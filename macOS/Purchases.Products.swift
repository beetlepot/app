import AppKit
import StoreKit
import Combine

extension Purchases {
    final class Products: NSView, NSPageControllerDelegate {
        private weak var stack: NSStackView!
        private var subs = Set<AnyCancellable>()
        private let controller = NSPageController()
        
        required init?(coder: NSCoder) { nil }
        init(products: [Product]) {
            super.init(frame: .zero)
            controller.delegate = self
            controller.transitionStyle = .horizontalStrip
            controller.view = .init(frame: .init(x: 1, y: 100, width: 398, height: 300))
            addSubview(controller.view)
            controller.arrangedObjects = products
            
            let stack = NSStackView(
                views: products
                    .enumerated()
                    .map { product in
                        let indicator = Indicator(id: product.1.id)
                        indicator.state = product.0 == 0 ? .selected : .on
                        indicator
                            .click
                            .sink { [weak self] in
                                self?.move(to: product.0)
                            }
                            .store(in: &subs)
                        return indicator
                    })
            stack.spacing = 10
            self.stack = stack
            addSubview(stack)
            
            stack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60).isActive = true
        }
        
        func pageController(_: NSPageController, identifierFor: Any) -> NSPageController.ObjectIdentifier {
            .init()
        }
        
        func pageController(_: NSPageController, viewControllerForIdentifier: NSPageController.ObjectIdentifier) -> NSViewController {
            let controller = NSViewController()
            controller.view = Item()
            return controller
        }
        
        func pageController(_: NSPageController, prepare: NSViewController, with: Any?) {
            (prepare.view as? Item)?.product = with as? Product
        }
        
        func pageController(_: NSPageController, didTransitionTo: Any) {
            guard let id = (didTransitionTo as? Product)?.id else { return }
            
            stack
                .views
                .compactMap {
                    $0 as? Indicator
                }
                .forEach {
                    $0.state = $0.id == id ? .selected : .on
                }
        }
        
        private func move(to: Int) {
            NSAnimationContext
                .runAnimationGroup { _ in
                    controller.animator().selectedIndex = to
                } completionHandler: { [weak self] in
                    self?.controller.completeTransition()
                }
        }
    }
}
