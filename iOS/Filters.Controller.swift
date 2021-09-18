import SwiftUI

extension Filters {
    final class Controller: UIHostingController<Content> {
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            sheetPresentationController
                .map {
                    $0.detents = [.medium()]
                }
        }
    }
}
