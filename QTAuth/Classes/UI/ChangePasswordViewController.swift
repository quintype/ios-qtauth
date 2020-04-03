//
//  ChangePasswordViewController.swift
//  QTAuth
//
//  Created by Maulik Sharma on 16/12/19.
//

import UIKit
import MaterialComponents

class ChangePasswordViewController: AuthBaseViewController {
    
    // MARK: Outlets
    @IBOutlet weak var otpTextField: MDCTextField!
    @IBOutlet weak var passwordTextField: MDCTextField!
    @IBOutlet weak var resetButton: UIButton!
    
    // MARK: Properties
    var otpController: MDCTextInputControllerOutlined!
    var passwordController: MDCTextInputControllerOutlined!
    var memberData: AuthMember?
    var xQTAuth: String!
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otpController = MDCTextInputControllerOutlined(textInput: otpTextField)
        passwordController = MDCTextInputControllerOutlined(textInput: passwordTextField)
        otpTextField.clearButtonMode = .never
        otpTextField.rightViewMode = .always
        otpTextField.rightView = ShowPasswordView(textField: otpTextField, frame: CGRect(x: 0, y: 0, width: 28, height: 32))
        otpTextField.translatesAutoresizingMaskIntoConstraints = false
        otpTextField.rightView?.widthAnchor.constraint(equalToConstant: 28).isActive = true
        otpTextField.rightView?.heightAnchor.constraint(equalToConstant: 32).isActive = true
        passwordTextField.clearButtonMode = .never
        passwordTextField.rightViewMode = .always
        passwordTextField.rightView = ShowPasswordView(textField: passwordTextField, frame: CGRect(x: 0, y: 0, width: 28, height: 32))
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.rightView?.widthAnchor.constraint(equalToConstant: 28).isActive = true
        passwordTextField.rightView?.heightAnchor.constraint(equalToConstant: 32).isActive = true
        resetButton.layer.cornerRadius = 3
        otpTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        triggerOTP()
    }
    
    // MARK: Input Validation
    
    private func validateOTP() -> Int? {
        guard let text = otpTextField.text, !text.isEmpty else {
            otpController.setErrorText("Please enter the OTP.", errorAccessibilityValue: nil)
            return nil
        }
        guard let otp = Int(text) else {
            otpController.setErrorText("Please enter a valid OTP", errorAccessibilityValue: nil)
            return nil
        }
        otpController.setErrorText(nil, errorAccessibilityValue: nil)
        return otp
    }
    
    private func validatePassword() -> String? {
        guard let text = passwordTextField.text, !text.isEmpty else {
            passwordController.setErrorText("Please enter your password.", errorAccessibilityValue: nil)
            return nil
        }
        passwordController.setErrorText(nil, errorAccessibilityValue: nil)
        return text
    }
    
    // MARK: Methods
    
    @IBAction func triggerOTP() {
        guard let email = memberData?.email else { return }
        presentLoadingAlertController()
        QTAuth.instance.apiManager.sendOTP(email: email) { [weak self] (isSuccess, error) in
            DispatchQueue.main.async {
                self?.dismissLoadingAlertController() {_ in
                    if let error = error {
                        self?.displayAlertWith(title: "Error", message: error.errorMessage, okTitle: "OK")
                    }
                    if isSuccess {
                        let message = "Please check your email for one time password (OTP)"
                        self?.displayAlertWith(title: "Sent OTP", message: message, okTitle: "OK")
                    }
                }
            }
        }
    }
    
    @IBAction func changePassword() {
        guard let otp = validateOTP(), let password = validatePassword(), let id = memberData?.id else { return }
        presentLoadingAlertController()
        QTAuth.instance.apiManager.changePassword(id: id, otp: otp, password: password, xQTAuth: xQTAuth) { [weak self] (response, error) in
            DispatchQueue.main.async {
                self?.dismissLoadingAlertController() {_ in
                    if let error = error {
                        self?.displayAlertWith(title: "Error", message: error.errorMessage, okTitle: "OK")
                    }
                    if response?.member != nil {
                        let message = "Password changed successfully"
                        self?.displayAlertWith(title: "Success", message: message, okTitle: "OK") { [weak self] (_) in
                            self?.popAuthViewControllers()
                        }
                    }
                }
            }
        }
    }
    
}

// MARK: TextFieldDelegate Methods

extension ChangePasswordViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == otpTextField {
            otpController.setErrorText(nil, errorAccessibilityValue: nil)
        } else if textField == passwordTextField {
            passwordController.setErrorText(nil, errorAccessibilityValue: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == otpTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordController {
            textField.resignFirstResponder()
            changePassword()
        }
        return true
    }
    
}
