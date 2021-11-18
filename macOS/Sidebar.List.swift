import AppKit
import Combine

extension Sidebar {
    final class List: Collection<Cell, Info>, NSMenuDelegate {
        static let width = CGFloat(300)
        private static let insets = CGFloat(30)
        private static let insets2 = insets + insets
        private let select = PassthroughSubject<CGPoint, Never>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(active: .activeInKeyWindow)
            menu = .init()
            menu!.delegate = self
            
            let vertical = CGFloat(30)
            let info = PassthroughSubject<[Info], Never>()
            
            info
                .removeDuplicates()
                .sink { [weak self] info in
                    let result = info
                        .reduce(into: (items: Set<CollectionItem<Info>>(), y: vertical)) {
                            $0.items.insert(.init(
                                                info: $1,
                                                rect: .init(
                                                    x: Self.insets,
                                                    y: $0.y,
                                                    width: Self.width,
                                                    height: Cell.height)))
                            $0.y += Cell.height + 1
                        }
                    self?.items.send(result.items)
                    self?.size.send(.init(width: 0, height: result.y + vertical))
                }
                .store(in: &subs)
            
            select
                .map { [weak self] point in
                    self?
                        .cells
                        .compactMap(\.item)
                        .first {
                            $0
                                .rect
                                .contains(point)
                        }
                }
                .compactMap {
                    $0?.info.id
                }
                .sink { [weak self] id in
                    
                }
                .store(in: &subs)
        }
        
        final override func mouseUp(with: NSEvent) {
            switch with.clickCount {
            case 1:
                select.send(point(with: with))
            default:
                break
            }
        }
        
        final func menuNeedsUpdate(_ menu: NSMenu) {
            menu.items = highlighted.value == nil
                ? []
                : [
                    .child("Open", #selector(open)) {
                        $0.target = self
                        $0.image = .init(systemSymbolName: "arrow.up", accessibilityDescription: nil)
                    },
                    .separator(),
                    .child("Delete", #selector(delete)) {
                        $0.target = self
                        $0.image = .init(systemSymbolName: "trash", accessibilityDescription: nil)
                    }]
        }
        
        @objc private func open() {
            highlighted
                .value
                .map { id in
                    
                }
        }
        
        @objc private func delete() {
            highlighted
                .value
                .map { id in
                    
                }
        }
    }

}
