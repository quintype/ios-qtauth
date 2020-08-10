//
//  MyProfileViewController.swift
//  QTAuth
//
//  Created by Maulik Sharma on 30/12/19.
//

import UIKit
import FacebookLogin

class MyProfileViewController: AuthBaseViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    
    @IBOutlet weak var addressStackView: UIStackView!
    @IBOutlet weak var dobStackView: UIStackView!
    @IBOutlet weak var contactStackView: UIStackView!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    
    @IBOutlet weak var profilePic: UIImageView!
    
    // MARK: Properties
    var xQTAuth: String!
    var memberData: AuthMember? {
        didSet {
            guard let member = memberData else { return }
            nameLabel.text = member.name
            emailLabel.text = member.email
            addressStackView.isHidden = member.metadata?.address?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
            addressLabel.text = member.metadata?.address
            dobStackView.isHidden = member.metadata?.dob?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
            dobLabel.text = member.metadata?.dob
            contactStackView.isHidden = member.metadata?.contact?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
            contactLabel.text = member.metadata?.contact
            if let avatarUrl = member.avatarUrl {
                //setImage(from: avatarUrl)
                profilePic.imageFromURL(urlString: avatarUrl)
            }
            
        }
    }
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let memberInfo = QTAuth.instance.signedInMemberInfo, let xQTAuth = memberInfo.xQTAuth else {
            displayAlertWith(title: "Error", message: "Did not receive x-qt-quth", okTitle: "OK") { [weak self] (_) in
                self?.popAuthViewControllers()
            }
            return
        }
        profilePic.layer.cornerRadius = self.profilePic.frame.height/2
        profilePic.clipsToBounds = true
        profilePic.contentMode = .scaleAspectFill
        self.xQTAuth = xQTAuth
        nameLabel.text = memberInfo.member?.name
        emailLabel.text = memberInfo.member?.email
        changePasswordButton.isHidden = memberInfo.provider != nil || memberInfo.member?.verificationStatus?.contains("social") ?? false
        self.navigationItem.title = "My Profile"
        let customBackButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = customBackButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateMemberInfo()
    }
    
    // MARK: Methods
    
    func updateMemberInfo() {
        presentLoadingAlertController()
        QTAuth.instance.apiManager.fetchMember(xQTAuth: xQTAuth) { [weak self] (response, error) in
            DispatchQueue.main.async {
                self?.dismissLoadingAlertController() {_ in
                    if let error = error {
                        self?.displayAlertWith(title: "Error", message: error.errorMessage, okTitle: "OK")
                    }
                    
                    QTAuth.instance.signedInMemberInfo = response
                    if let member = response?.member {
                        self?.memberData = member
                    }
                }
            }
        }
    }
    
    @IBAction func signOut() {
        presentLoadingAlertController()
        QTAuth.instance.apiManager.signOut(xQTAuth: xQTAuth) { [weak self] (isSuccess, error) in
            DispatchQueue.main.async {
                if let _ = AccessToken.current {
                    LoginManager().logOut()
                }
                self?.dismissLoadingAlertController(){_ in 
                if let error = error {
                    self?.displayAlertWith(title: "Error", message: error.errorMessage, okTitle: "OK")
                }
                if isSuccess {
                    QTAuth.instance.signedInMemberInfo = nil
                    self?.popAuthViewControllers()
                }
                    
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editProfileVC = segue.destination as? EditProfileViewController {
            editProfileVC.xQTAuth = xQTAuth
            editProfileVC.memberData = memberData
        } else if let changePasswordVC = segue.destination as? ChangePasswordViewController {
            changePasswordVC.xQTAuth = xQTAuth
            changePasswordVC.memberData = memberData
        }
    }
    
}
