//
//  ResetPasswordViewController.swift
//  QTAuth
//
//  Created by Maulik Sharma on 16/12/19.
//

import UIKit
import MaterialComponents

class ResetPasswordViewController: AuthBaseViewController {
    
    // MARK: Outlets
    @IBOutlet weak var emailTextField: MDCTextField!
    @IBOutlet weak var continueButton: UIButton!
    var urlString: String?
    
    // MARK: Properties
    var emailController: MDCTextInputControllerOutlined!
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailController = MDCTextInputControllerOutlined(textInput: emailTextField)
        continueButton.layer.cornerRadius = 3
        emailTextField.delegate = self
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = SegueIdentifier(rawValue: segue.identifier ?? "") {
            switch identifier {
            case .staticPageSegue:
                if let controller = segue.destination as? WebViewController {
                    controller.urlString = self.urlString
                    
                }
                break
            default:
                break
                
            }
        }
        
    }
    
    // MARK: Input Validation
    
    private func validateEmail() -> String? {
        guard let text = emailTextField.text, !text.isEmpty else {
            emailController.setErrorText("Please enter your email.", errorAccessibilityValue: nil)
            return nil
        }
        if text.isValidEmailID {
            emailController.setErrorText(nil, errorAccessibilityValue: nil)
            return text
        }
        emailController.setErrorText("Please enter a valid email.", errorAccessibilityValue: nil)
        return nil
    }
    
    
    // MARK: Methods
    
    @IBAction func privacyPolicy(_ sender: UIButton) {
        self.urlString = StaticPageUrl.privacyPolicy
        self.performSegue(withIdentifier: SegueIdentifier.staticPageSegue.rawValue, sender: nil)
    }
    @IBAction func termsOfService(_ sender: UIButton) {
        self.urlString = StaticPageUrl.termsAndCondition
        self.performSegue(withIdentifier: SegueIdentifier.staticPageSegue.rawValue, sender: nil)
    }
    @IBAction func triggerResetPassword() {
        guard let email = validateEmail() else { return }
        presentLoadingAlertController()
        QTAuth.instance.apiManager.resetPassword(email: email) { [weak self] (isSuccess, error) in
            DispatchQueue.main.async {
                self?.dismissLoadingAlertController(){_ in
                    if let error = error {
                        self?.displayAlertWith(title: "Error", message: error.errorMessage, okTitle: "OK")
                    }
                    if isSuccess {
                        let message = "We have sent a reset link to you at \(email). Please check your inbox"
                        self?.displayAlertWith(title: "Activate", message: message, okTitle: "OK", cancelTitle: nil, completionBlock: { [weak self] (_) in
                            self?.popAuthViewControllers()
                        })
                    }
                }
            }
        }
    }
    
}

// MARK: TextFieldDelegate Methods

extension ResetPasswordViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailController.setErrorText(nil, errorAccessibilityValue: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            if let text = textField.text, !text.isValidEmailID {
                emailController.setErrorText("Please enter a valid email", errorAccessibilityValue: nil)
            }
            textField.resignFirstResponder()
            triggerResetPassword()
        }
        return true
    }
    
}
