import AppKit
import Combine

final class Capacity: NSWindow {
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 340, height: 260),
                   styleMask: [.closable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        animationBehavior = .alertPanel
        toolbar = .init()
        isReleasedWhenClosed = false
        titlebarAppearsTransparent = true
        center()
        
        let content = NSVisualEffectView()
        content.wantsLayer = true
        content.state = .active
        content.material = .menu
        contentView = content
        
        let vibrant = Vibrant(layer: false)
        vibrant.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(vibrant)
        
        let title = Text(vibrancy: true)
        title.stringValue = "Capacity"
        title.font = .preferredFont(forTextStyle: .title3)
        title.textColor = .tertiaryLabelColor
        vibrant.addSubview(title)
        
        let icon = Image(icon: "lock.square.stack")
        icon.symbolConfiguration = .init(textStyle: .title3)
            .applying(.init(hierarchicalColor: .tertiaryLabelColor))
        vibrant.addSubview(icon)
        
        let stats = Text(vibrancy: true)
        content.addSubview(stats)
        
        let ring = Shape()
        ring.frame = .init(x: 50, y: 40, width: 150, height: 150)
        ring.strokeColor = NSColor.controlAccentColor.withAlphaComponent(0.15).cgColor
        ring.fillColor = .clear
        ring.lineWidth = 14
        ring.path = {
            $0.addArc(center: .init(x: 75, y: 75), radius: 70, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
            return $0
        } (CGMutablePath())
        content.layer!.addSublayer(ring)
        
        let progress = Shape()
        progress.frame = .init(origin: .zero, size: ring.frame.size)
        progress.strokeColor = .white
        progress.fillColor = .clear
        progress.lineWidth = 10
        progress.lineCap = .round
        
        let gradient = Gradient()
        gradient.frame = ring.frame
        gradient.startPoint = .init(x: 0.5, y: 0)
        gradient.endPoint = .init(x: 0.5, y: 1)
        gradient.locations = [0, 1]
        gradient.colors = [NSColor.controlAccentColor.cgColor, NSColor(named: "Spot")!.cgColor]
        gradient.mask = progress
        content.layer!.addSublayer(gradient)
        
        vibrant.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
        vibrant.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -26).isActive = true
        vibrant.heightAnchor.constraint(equalToConstant: 52).isActive = true
        vibrant.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        title.centerYAnchor.constraint(equalTo: vibrant.centerYAnchor).isActive = true
        title.rightAnchor.constraint(equalTo: icon.leftAnchor, constant: -10).isActive = true
        
        icon.rightAnchor.constraint(equalTo: vibrant.rightAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: vibrant.centerYAnchor).isActive = true
        
        stats.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -30).isActive = true
        stats.centerYAnchor.constraint(equalTo: content.centerYAnchor, constant: 10).isActive = true
        
        cloud
            .map { model -> (count: Int, capacity: Int) in
                (count: model.count, capacity: model.capacity)
            }
            .removeDuplicates { (previous: (count: Int, capacity: Int), now: (count: Int, capacity: Int)) in
                previous.count == now.count && previous.capacity == now.capacity
            }
            .sink { (count: Int, capacity: Int) in
                let percent = Double(count) / max(Double(capacity), 1)
                
                stats.attributedStringValue = .make(alignment: .right) {
                    $0.append(.make(count.formatted(), attributes: [
                        .font: NSFont.monospacedSystemFont(ofSize: 20, weight: .thin),
                        .foregroundColor: NSColor.labelColor]))
                    $0.newLine()
                    $0.append(.make("Secrets", attributes: [
                        .font: NSFont.preferredFont(forTextStyle: .body),
                        .foregroundColor: NSColor.tertiaryLabelColor]))
                    $0.newLine()
                    $0.newLine()
                    $0.append(.make(capacity.formatted(), attributes: [
                        .font: NSFont.monospacedSystemFont(ofSize: 20, weight: .thin),
                        .foregroundColor: NSColor.labelColor]))
                    $0.newLine()
                    $0.append(.make("Capacity", attributes: [
                        .font: NSFont.preferredFont(forTextStyle: .body),
                        .foregroundColor: NSColor.tertiaryLabelColor]))
                    $0.newLine()
                    $0.newLine()
                    $0.append(.make(percent.formatted(.percent), attributes: [
                        .font: NSFont.monospacedSystemFont(ofSize: 20, weight: .thin),
                        .foregroundColor: NSColor.labelColor]))
                    $0.newLine()
                    $0.append(.make("Used", attributes: [
                        .font: NSFont.preferredFont(forTextStyle: .body),
                        .foregroundColor: NSColor.tertiaryLabelColor]))
                }
                
                progress.path = {
                    $0.addArc(center: .init(x: 75, y: 75),
                              radius: 70,
                              startAngle: .pi / 2,
                              endAngle: .pi / 2 + (.pi * -2 * percent),
                              clockwise: true)
                    return $0
                } (CGMutablePath())
                
                progress.add({
                    $0.duration = 2
                    $0.fromValue = 0
                    $0.toValue = 1
                    $0.timingFunction = .init(name: .easeInEaseOut)
                    return $0
                } (CABasicAnimation(keyPath: "strokeEnd")), forKey: "strokeEnd")
            }
            .store(in: &subs)
    }
}
