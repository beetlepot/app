import SwiftUI

extension Tags {
    final class Controller: UIHostingController<Content> {
        deinit {
            print("controller gone")
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            print("controller appear")
            sheetPresentationController
                .map {
                    $0.detents = [.medium(), .large()]
                    $0.prefersGrabberVisible = true
                }
        }
    }
}
