import Foundation
import UIKit

extension UIApplication {
    func settings() {
        open(URL(string: Self.openSettingsURLString)!)
    }
    
    func hide() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
