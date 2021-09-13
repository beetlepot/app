import Foundation

extension Sidebar {
    enum Pop: Identifiable {
        var id: String {
            "\(self)"
        }
        
        case
        tags,
        full,
        create(Int)
    }
}
