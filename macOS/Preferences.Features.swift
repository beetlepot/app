import AppKit
import Secrets

extension Preferences {
    final class Features: Tab {
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(size: .init(width: 320, height: 200), title: "Features", symbol: "switch.2")
            
            let spell = Switch(title: "Spell checking", target: self, action: #selector(spell))
            spell.control.state = Defaults.spell ? .on : .off
            
            let correction = Switch(title: "Auto correction", target: self, action: #selector(correction))
            correction.control.state = Defaults.correction ? .on : .off
            
            let stack = NSStackView(views: [spell,
                                            Separator(mode: .horizontal),
                                            correction])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.orientation = .vertical
            stack.alignment = .leading
            stack.spacing = 10
            view!.addSubview(stack)
            
            stack.centerYAnchor.constraint(equalTo: view!.centerYAnchor).isActive = true
            stack.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
        }
        
        @objc private func spell(_ toggle: NSSwitch) {
            Defaults.spell = toggle.state == .on
        }
        
        @objc private func correction(_ toggle: NSSwitch) {
            Defaults.correction = toggle.state == .on
        }
    }
}
