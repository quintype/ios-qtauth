//
//  SignInViewController.swift
//  QTAuth
//
//  Created by Maulik Sharma on 12/12/19.
//

import UIKit
import MaterialComponents
import GoogleSignIn
import FacebookLogin

enum InputValidationState: Equatable {
    case invalid(String?)
    case valid
}

class SignInViewController: AuthBaseViewController {
    
    // MARK: Outlets
    @IBOutlet weak var emailTextField: MDCTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var passwordTextField: MDCTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    var urlString: String?
    // MARK: Properties
    var emailController: MDCTextInputControllerOutlined!
    var passwordController: MDCTextInputControllerOutlined!
    //var emailVerificationSegueIdentifier = "SignInEmailVerificationSegue"
    
    var memberResponse: MemberResponse? {
        didSet {
            guard memberResponse?.member?.verificationStatus != nil else {
                self.performSegue(withIdentifier: SegueIdentifier.signInEmailVerificationSegue.rawValue, sender: nil)
                return
            }
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
        emailController = MDCTextInputControllerOutlined(textInput: emailTextField)
        passwordController = MDCTextInputControllerOutlined(textInput: passwordTextField)
        passwordTextField.clearButtonMode = .never
        passwordTextField.rightViewMode = .always
        passwordTextField.rightView = ShowPasswordView(textField: passwordTextField, frame: CGRect(x: 0, y: 0, width: 28, height: 32))
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.rightView?.widthAnchor.constraint(equalToConstant: 28).isActive = true
        passwordTextField.rightView?.heightAnchor.constraint(equalToConstant: 32).isActive = true
        loginButton.layer.cornerRadius = 3
        let borderColor = UIColor(fromHex: "#D8D8D8").cgColor
        facebookButton.addBorder(width: 1, radius: 8, color: borderColor)
        googleButton.addBorder(width: 1, radius: 8, color: borderColor)
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
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
    
    private func validatePassword() -> String? {
        guard let text = passwordTextField.text, !text.isEmpty else {
            passwordController.setErrorText("Please enter your password.", errorAccessibilityValue: nil)
            return nil
        }
        passwordController.setErrorText(nil, errorAccessibilityValue: nil)
        return text
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
    @IBAction func signIn() {
        guard let email = validateEmail(), let password = validatePassword() else { return }
        presentLoadingAlertController()
        QTAuth.instance.apiManager.signIn(email: email, password: password) { [weak self] (response, error) in
            DispatchQueue.main.async {
                self?.dismissLoadingAlertController() { _ in
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
    
    @IBAction func googleSignIn() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func facebookSignIn() {
        fbSignIn()
    }
    
    func socialSignIn(provider: String, token: String) {
        presentLoadingAlertController()
        QTAuth.instance.apiManager.socialSignIn(provider: provider, accessToken: token) { [weak self] (response, error) in
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
    
    @IBAction func unwindFromSignUp(unwindSegue: UIStoryboardSegue) {}
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = SegueIdentifier(rawValue: segue.identifier ?? "") {
            switch identifier {
            case .staticPageSegue:
                if let controller = segue.destination as? WebViewController {
                    controller.urlString = self.urlString
                }
            default:
                if let emailVerificationVC = segue.destination as? EmailVerificationViewController {
                    guard let member = memberResponse?.member else { return }
                    emailVerificationVC.emailID = member.email
                    emailVerificationVC.memberID = member.id
                    emailVerificationVC.seguedFromSignIn = true
                }
                
            }
            
        }
        
    }
}

// MARK: TextFieldDelegate Methods

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailController.setErrorText(nil, errorAccessibilityValue: nil)
            passwordController.setErrorText(nil, errorAccessibilityValue: nil)
        } else if textField == passwordTextField {
            passwordController.setErrorText(nil, errorAccessibilityValue: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            if let text = textField.text, !text.isValidEmailID {
                emailController.setErrorText("Please enter a valid email", errorAccessibilityValue: nil)
            }
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            textField.resignFirstResponder()
            signIn()
        }
        return true
    }
    
}

// MARK: Social Login

extension SignInViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                let message = "The user has not signed in before or they have since signed out."
                self.displayAlertWith(title: "Error", message: message, okTitle: "OK")
            } else {
                self.displayAlertWith(title: "Error", message: error.localizedDescription, okTitle: "OK")
            }
            QTAuth.instance.didFinishSignin(nil, .authFailed)
            return
        }
        guard let token = user.authentication.accessToken else { return }
        self.socialSignIn(provider: "google", token: token)
    }
    
    func fbSignIn() {
        let loginManager = LoginManager()
        if let _ = AccessToken.current {
            loginManager.logOut()
        }
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: self) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .cancelled:
                    let message = "Login cancelled."
                    self?.displayAlertWith(title: "Error", message: message, okTitle: "OK")
                case .failed(let error):
                    let message = "Login failed with error \(error)"
                    self?.displayAlertWith(title: "Error", message: message, okTitle: "OK")
                case .success:
                    guard let token = AccessToken.current?.tokenString else {
                        let message = "Couldn't retrieve access token from Facebook"
                        self?.displayAlertWith(title: "Error", message: message, okTitle: "OK")
                        return
                    }
                    self?.socialSignIn(provider: "facebook", token: token)
                }
            }
        }
    }
    
}
