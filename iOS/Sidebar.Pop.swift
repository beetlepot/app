import Foundation

extension Sidebar {
    enum Pop: Identifiable {
        var id: String {
            "\(self)"
        }
        
        case
        full,
        create(Int)
    }
}
