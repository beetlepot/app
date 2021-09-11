import SwiftUI

struct Ring: Shape {
    var amount: Double
    
    func path(in rect: CGRect) -> SwiftUI.Path {
        .init {
            $0.addArc(
                center: .init(x: rect.width / 2, y: rect.height / 2),
                radius: (min(rect.width, rect.height) / 2) - 8,
                startAngle: .init(degrees: -90),
                endAngle: .init(degrees: (360 * amount) - 90),
                clockwise: false)
        }
    }
    
    var animatableData: Double {
        get { amount }
        set { amount = newValue }
    }
}
