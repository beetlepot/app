import AppKit
import Secrets

extension Preferences {
    final class Security: Tab {
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(size: .init(width: 400, height: 180), title: "Security", symbol: "touchid")
            
            let text = Text(vibrancy: true)
            text.stringValue = "Secure your secrets and request authentication with Touch ID."
            text.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .regular)
            text.textColor = .secondaryLabelColor
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            
            let touchid = Switch(title: "Touch ID", target: self, action: #selector(touchid))
            touchid.control.state = Defaults.authenticate ? .on : .off
            
            let stack = NSStackView(views: [
                text,
                touchid])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.orientation = .vertical
            stack.alignment = .leading
            stack.spacing = 10
            view!.addSubview(stack)
            
            stack.centerYAnchor.constraint(equalTo: view!.centerYAnchor).isActive = true
            stack.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
            
            text.widthAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        }
        
        @objc private func touchid(_ toggle: NSSwitch) {
            Defaults.authenticate = toggle.state == .on
        }
    }
}
