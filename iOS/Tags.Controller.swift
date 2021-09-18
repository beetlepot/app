import SwiftUI

extension Tags {
    final class Controller: UIHostingController<Content> {
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            sheetPresentationController
                .map {
                    $0.detents = [.medium(), .large()]
                    $0.prefersGrabberVisible = true
                }
        }
    }
}
