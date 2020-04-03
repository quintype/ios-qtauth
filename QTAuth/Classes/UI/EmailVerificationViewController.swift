//
//  EmailVerificationViewController.swift
//  QTAuth
//
//  Created by Maulik Sharma on 14/12/19.
//

import UIKit
import MaterialComponents

class EmailVerificationViewController: AuthBaseViewController {
    
    // MARK: Outlets
    @IBOutlet weak var otpTextField: MDCTextField!
    @IBOutlet weak var verifyButton: UIButton!
    
    // MARK: Properties
    var otpController: MDCTextInputControllerOutlined!
    var seguedFromSignIn: Bool = false
    var emailID: String?
    var memberID: Int?
    var urlString: String?
    
    var memberResponse: MemberResponse? {
        didSet {
            guard memberResponse?.xQTAuth != nil else {
                displayAlertWith(title: "Error", message: "Did not receive x-qt-quth", okTitle: "OK")
                return
            }
            QTAuth.instance.signedInMemberInfo = memberResponse
            popAuthViewControllers()
        }
    }
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otpController = MDCTextInputControllerOutlined(textInput: otpTextField)
        otpTextField.clearButtonMode = .never
        otpTextField.rightViewMode = .always
        otpTextField.rightView = ShowPasswordView(textField: otpTextField, frame: CGRect(x: 0, y: 0, width: 28, height: 32))
        otpTextField.translatesAutoresizingMaskIntoConstraints = false
        otpTextField.rightView?.widthAnchor.constraint(equalToConstant: 28).isActive = true
        otpTextField.rightView?.heightAnchor.constraint(equalToConstant: 32).isActive = true
        verifyButton.layer.cornerRadius = 3
        otpTextField.delegate = self
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
    
    // MARK: Methods
    
    @IBAction func privacyPolicy(_ sender: UIButton) {
        self.urlString = StaticPageUrl.privacyPolicy
        self.performSegue(withIdentifier: SegueIdentifier.staticPageSegue.rawValue, sender: nil)
    }
    @IBAction func termsOfService(_ sender: UIButton) {
        self.urlString = StaticPageUrl.termsAndCondition
        self.performSegue(withIdentifier: SegueIdentifier.staticPageSegue.rawValue, sender: nil)
    }
    @IBAction func triggerOTP() {
        guard let email = emailID else { return }
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
    
    @IBAction func verifyOTP() {
        guard let otp = validateOTP(), let id = memberID else { return }
        presentLoadingAlertController()
        QTAuth.instance.apiManager.verifyOTP(id: id, otp: otp) { [weak self] (response, error) in
            DispatchQueue.main.async {
                self?.dismissLoadingAlertController() {_ in 
                if let error = error {
                    self?.displayAlertWith(title: "Error", message: error.errorMessage, okTitle: "OK")
                }
                if response?.member != nil {
                    self?.memberResponse = response
                }
                }
            }
        }
    }
    
}

// MARK: TextFieldDelegate Methods

extension EmailVerificationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == otpTextField {
            otpController.setErrorText(nil, errorAccessibilityValue: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == otpTextField {
            textField.resignFirstResponder()
            verifyOTP()
        }
        return true
    }
    
}
