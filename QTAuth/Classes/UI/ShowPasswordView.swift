//
//  ShowPasswordView.swift
//  QTAuth
//
//  Created by Maulik Sharma on 03/01/20.
//

import Foundation
import UIKit

class ShowPasswordView: UIImageView {
    
    let button = UIButton()
    var textField: UITextField?
    
    func setup() {
        image = UIImage(named: "eyeClosed")
        contentMode = .scaleAspectFit
        isUserInteractionEnabled = true
        addSubview(button)
        button.fillSuperview(with: .zero)
        button.addTarget(self, action: #selector(toggleSecureEntry), for: .touchUpInside)
    }
    
    @objc func toggleSecureEntry() {
        guard let textField = textField else { return }
        textField.togglePasswordVisibility() 
        image = textField.isSecureTextEntry ? UIImage(named: "eyeClosed") : UIImage(named: "eyeOpened")
    }
    
    convenience init(textField: UITextField, frame: CGRect) {
        self.init(frame: frame)
        self.textField = textField
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension UITextField {
    func togglePasswordVisibility() {
        isSecureTextEntry.toggle()

        if let existingText = text, isSecureTextEntry {
            /* When toggling to secure text, all text will be purged if the user
             continues typing unless we intervene. This is prevented by first
             deleting the existing text and then recovering the original text. */
            deleteBackward()

            if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                replace(textRange, withText: existingText)
            }
        }

        /* Reset the selected text range since the cursor can end up in the wrong
         position after a toggle because the text might vary in width */
        if let existingSelectedTextRange = selectedTextRange {
            selectedTextRange = nil
            selectedTextRange = existingSelectedTextRange
        }
    }
}
