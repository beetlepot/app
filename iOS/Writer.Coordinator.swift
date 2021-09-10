import UIKit
import Combine
import Secrets
import SwiftUI

extension Writer {
    final class Coordinator: UITextView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(index: Int, secret: Secret, submit: PassthroughSubject<Void, Never>) {
            super.init(frame: .zero, textContainer: Container())
            typingAttributes[.font] = UIFont.monospacedSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title3).pointSize, weight: .regular)
            typingAttributes[.kern] = 1
            font = typingAttributes[.font] as? UIFont
            textContainerInset = UIDevice.pad
                ? .init(top: 80, left: 80, bottom: 80, right: 80)
                : .init(top: 20, left: 20, bottom: 30, right: 20)
            keyboardDismissMode = .none
            backgroundColor = .clear
            tintColor = .label
            autocapitalizationType = .sentences
            autocorrectionType = Defaults.correction ? .yes : .no
            spellCheckingType = Defaults.spell ? .yes : .no
            alwaysBounceVertical = true
            allowsEditingTextAttributes = false
            text = secret.payload
            
            if Defaults.tools {
                tools()
            }
            
            DispatchQueue
                .main
                .asyncAfter(deadline: .now() + 0.75) { [weak self] in
                    self?.becomeFirstResponder()
                }
            
            submit
                .sink { [weak self] in
                    guard let text = self?.text.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
                    Task {
                        await cloud.update(index: index, payload: text)
                        await UNUserNotificationCenter.send(message: "Edited secret!")
                    }
                }
                .store(in: &subs)
        }
        
        override func caretRect(for position: UITextPosition) -> CGRect {
            var rect = super.caretRect(for: position)
            rect.size.width = 2
            return rect
        }
        
        private func tools() {
            let input = UIInputView(frame: .init(x: 0, y: 0, width: 0, height: 48), inputViewStyle: .keyboard)
            
            let number = UIButton(configuration: .bordered())
            number.setTitle("#", for: .init())
            number.addTarget(self, action: #selector(self.number), for: .touchUpInside)
            
            let minus = UIButton(configuration: .bordered())
            minus.setTitle("—", for: .init())
            minus.addTarget(self, action: #selector(self.minus), for: .touchUpInside)
            
            let underscore = UIButton(configuration: .bordered())
            underscore.setTitle("_", for: .init())
            underscore.addTarget(self, action: #selector(self.underscore), for: .touchUpInside)
            
            let backquote = UIButton(configuration: .bordered())
            backquote.setTitle("`", for: .init())
            backquote.addTarget(self, action: #selector(self.backquote), for: .touchUpInside)
            
            let asterisk = UIButton(configuration: .bordered())
            asterisk.setTitle("*", for: .init())
            asterisk.addTarget(self, action: #selector(self.asterisk), for: .touchUpInside)
            
            [number, minus, underscore, backquote, asterisk].forEach {
                $0.titleLabel!.font = .monospacedSystemFont(ofSize: 20, weight: .regular)
                $0.setTitleColor(.label, for: .normal)
                $0.setTitleColor(.tertiaryLabel, for: .highlighted)
                $0.translatesAutoresizingMaskIntoConstraints = false
                input.addSubview($0)
                
                $0.topAnchor.constraint(equalTo: input.topAnchor, constant: 8).isActive = true
                $0.bottomAnchor.constraint(equalTo: input.bottomAnchor, constant: -8).isActive = true
                $0.widthAnchor.constraint(equalToConstant: 54).isActive = true
            }
            
            [number, minus, asterisk]
                .forEach {
                    $0.imageView!.tintColor = .label
                }
            
            number.rightAnchor.constraint(equalTo: minus.leftAnchor, constant: -8).isActive = true
            minus.rightAnchor.constraint(equalTo: underscore.leftAnchor, constant: -8).isActive = true
            underscore.centerXAnchor.constraint(equalTo: input.centerXAnchor).isActive = true
            backquote.leftAnchor.constraint(equalTo: underscore.rightAnchor, constant: 8).isActive = true
            asterisk.leftAnchor.constraint(equalTo: backquote.rightAnchor, constant: 8).isActive = true
            
            inputAccessoryView = input
        }
        
        @objc private func asterisk() {
            insertText("*")
        }
        
        @objc private func minus() {
            insertText("—")
        }
        
        @objc private func underscore() {
            insertText("_")
        }
        
        @objc private func backquote() {
            insertText("`")
        }
        
        @objc private func number() {
            insertText("#")
        }
    }
}
