import SwiftUI

extension Filters {
    final class Controller: UIHostingController<Content> {
        deinit {
            print("filters gone")
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            print("filters appear")
            sheetPresentationController
                .map {
                    $0.detents = [.medium()]
                }
        }
    }
}
