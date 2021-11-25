import AppKit
import Combine
import Secrets

extension Tags {
    final class List: Collection<Cell, Info> {
        static let width = CGFloat(228)
        private static let insets = CGFloat(30)
        private static let insets2 = insets + insets
        private static let width_insets2 = width - insets2
        private let select = PassthroughSubject<CGPoint, Never>()
        
        deinit {
            print("list gone")
        }
        
        required init?(coder: NSCoder) { nil }
        init(id: Int, change: PassthroughSubject<Tag, Never>) {
            super.init(active: .activeInKeyWindow)
            scrollerInsets.bottom = 10
            
            let vertical = CGFloat(15)
            let info = PassthroughSubject<[Info], Never>()
            
            cloud
                .map {
                    $0[id].tags
                }
                .removeDuplicates()
                .sink { tags in
                    info.send(
                        Tag
                            .filtering(search: "")
                            .enumerated()
                            .map { tag in
                                .init(tag: tag.1, active: tags.contains(tag.1), first: tag.0 == 0)
                            })
                }
                .store(in: &subs)
            
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
                                                    width: Self.width_insets2,
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
                .sink { tag in
                    change.send(tag)
                }
                .store(in: &subs)
        }
        
        override func mouseUp(with: NSEvent) {
            switch with.clickCount {
            case 1:
                select.send(point(with: with))
            default:
                break
            }
        }
    }
}
