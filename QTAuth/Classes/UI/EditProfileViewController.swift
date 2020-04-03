//
//  EditProfileViewController.swift
//  QTAuth
//
//  Created by Maulik Sharma on 30/12/19.
//

import UIKit
import MaterialComponents

class EditProfileViewController: AuthBaseViewController {
    var elementName: String = String()
    var location = String()
    var key = String()
    // MARK: Outlets and Views
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTextField: MDCTextField!
    @IBOutlet weak var emailTextField: MDCTextField!
    @IBOutlet weak var dobTextField: MDCTextField!
    @IBOutlet weak var contactTextField: MDCTextField!
    @IBOutlet weak var addressTextField: MDCTextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var editSubView: UIView!
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: UIControl.Event.valueChanged)
        return datePicker
    }()
    
    // MARK: Properties
    var nameController: MDCTextInputControllerOutlined!
    var emailController: MDCTextInputControllerOutlined!
    var dobController: MDCTextInputControllerOutlined!
    var contactController: MDCTextInputControllerOutlined!
    var addressController: MDCTextInputControllerOutlined!
    
    var xQTAuth: String!
    var memberData: AuthMember?
    var imagePicker: ImagePicker!
    var isbackToPop: Bool = false
    
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButton.layer.cornerRadius = 3
        editSubView.layer.cornerRadius = 20
        editSubView.clipsToBounds = true
        nameController = MDCTextInputControllerOutlined(textInput: nameTextField)
        emailController = MDCTextInputControllerOutlined(textInput: emailTextField)
        dobController = MDCTextInputControllerOutlined(textInput: dobTextField)
        contactController = MDCTextInputControllerOutlined(textInput: contactTextField)
        addressController = MDCTextInputControllerOutlined(textInput: addressTextField)
        //nameController.borderFillColor = #colorLiteral(red: 0.9215686275, green: 0.937254902, blue: 0.937254902, alpha: 1) //Disabled textfield
       // emailController.borderFillColor = #colorLiteral(red: 0.9215686275, green: 0.937254902, blue: 0.937254902, alpha: 1) //Disabled textfield
        datePicker.setYearValidation()
        emailTextField.textColor = UIColor.lightGray
        dobTextField.inputView = datePicker
        setupAvailableDetails()
        handleProfilePic()
        self.navigationItem.title = "Edit Profile"
    }
    
    // MARK: Methods
    
    private func setupAvailableDetails() {
        nameTextField.text = memberData?.name
        emailTextField.text = memberData?.email
        dobTextField.text = memberData?.metadata?.dob
        contactTextField.text = memberData?.metadata?.contact
        addressTextField.text = memberData?.metadata?.address
        if let avatarUrl = memberData?.avatarUrl {
            profileImage.imageFromURL(urlString: avatarUrl)
        }
    }
    private func handleProfilePic() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImage.addGestureRecognizer(tap)
        editSubView.addGestureRecognizer(tap)
        editSubView.isUserInteractionEnabled = true
        profileImage.isUserInteractionEnabled = true
        self.profileImage.layer.cornerRadius = self.profileImage.frame.height/2
        self.profileImage.clipsToBounds = true
        self.profileImage.contentMode = .scaleAspectFill
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    @objc private func imageTapped() {
        self.imagePicker.present(from: self.profileImage)
    }
    
    
    @objc private func handleDatePicker() {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.dateFormat = "dd-MM-yyyy"
        dobTextField.text = formatter.string(from: datePicker.date)
    }
    
    @IBAction func updateMember() {
        let name: String? = (nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) ? nil : nameTextField.text
        let dob: String? = (dobTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) ? nil : dobTextField.text
        let contact: String? = (contactTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) ? nil : contactTextField.text
        let address: String? = (addressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) ? nil : addressTextField.text
        let newMetadata = MemberMetadata(dob: dob, gender: nil, address: address, contact: contact)
        presentLoadingAlertController()
        if  (dob != memberData?.metadata?.dob || (contact != memberData?.metadata?.contact && contact != nil) || address != memberData?.metadata?.address) && (name != memberData?.name) {
            self.updateBothUserAndMemberFileds(newMetadata: newMetadata, name: name ?? "")
            
        } else if (dob != memberData?.metadata?.dob || (contact != memberData?.metadata?.contact && contact != nil) || address != memberData?.metadata?.address) {
            self.updateMember(newMetadata: newMetadata)
            
        } else if (name != memberData?.name) {
            isbackToPop = true
            self.fetchMemberProfile(tempS3key: "", userName: name ?? "")
        } else {
            self.dismissLoadingAlertController() {[weak self] _ in
                self?.displayAlertWith(title: "No update", message: "There is no new information to update", okTitle: "OK")
            }
        }
    }
    fileprivate func imageSignIn(name: String, type: String, image: UIImage) {
        presentLoadingAlertController()
        QTAuth.instance.apiManager.imageSignIn(imageName: name, fileType: type) { [weak self] (imageData, error) in
            guard let imageSignData = imageData  else {
                DispatchQueue.main.async {
                    self?.dismissLoadingAlertController() {_ in }
                }
                return
            }
            self?.imageUploadMutiformData(image: image, imageFileName: name, signInModel: imageSignData)
        }
    }
    fileprivate func fetchMemberProfile(tempS3key: String, userName: String) {
        QTAuth.instance.apiManager.fetchMemberprofile(tempS3Key: tempS3key, userName: userName, xQTAuth: self.xQTAuth) { [weak self] (response, error) in
            DispatchQueue.main.async {
                self?.dismissLoadingAlertController() {_ in
                    if let error = error {
                        self?.displayAlertWith(title: "Error", message: error.errorMessage, okTitle: "OK")
                    }
                    if let _ = response {
                        QTAuth.instance.isProfilePicUpdate = true
                    }
                    if self?.isbackToPop ?? false {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    fileprivate func updateMember(newMetadata: MemberMetadata) {
        QTAuth.instance.apiManager.updateMember(metadata: newMetadata, xQTAuth: xQTAuth) { [weak self] (isSuccess, error) in
            DispatchQueue.main.async {
                self?.dismissLoadingAlertController() {_ in
                    if let error = error {
                        self?.displayAlertWith(title: "Error", message: error.localizedDescription, okTitle: "OK")
                    }
                    if isSuccess {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    fileprivate func updateBothUserAndMemberFileds(newMetadata: MemberMetadata, name: String) {
        let queue = DispatchQueue(label: "Serial queue")
        let group = DispatchGroup()
        group.enter()
        queue.async {
            sleep(1)
            QTAuth.instance.apiManager.updateMember(metadata: newMetadata, xQTAuth: self.xQTAuth) { (isSuccess, error) in
                if let _ = error {
                    print("Task 1 is  not completed")
                }
                if isSuccess {
                    print("Task 1 done")
                }
                group.leave()
            }
        }
        group.enter()
        queue.async {
            sleep(2)
            QTAuth.instance.apiManager.fetchMemberprofile(tempS3Key: "", userName: name, xQTAuth: self.xQTAuth) { (response, error) in
                if let _ = error { print("Task 2 is  not completed") }
                if let _ = response {
                    print("Task 2 done")
                    QTAuth.instance.isProfilePicUpdate = true
                }
                group.leave()
                
            }
        }
        
        group.notify(queue: queue) {
            DispatchQueue.main.async {
                self.dismissLoadingAlertController(){_ in
                    self.navigationController?.popViewController(animated: true)
                    print("All tasks done")
                }
            }
        }
    }
    fileprivate func imageUploadMutiformData(image: UIImage, imageFileName: String, signInModel: ImageSignInData) {
        let parameters:[String:String] = ["key": signInModel.key ?? "",
                                          "Content-Type": signInModel.content_Type ?? "", "policy": signInModel.policy ?? "", "acl": signInModel.acl ?? "", "success_action_status": signInModel.success_action_status ?? "", "AWSAccessKeyId" : signInModel.awsAccessKeyId ?? "", "signature": signInModel.signature ?? ""]
        
        guard let mediaImage = Media(withImage: image, forKey: "file", withType: signInModel.content_Type ?? "image/jpeg", fileName: imageFileName) else { return }
        
        guard let url = URL(string: signInModel.action ?? "") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = generateBoundary()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        
        let session = URLSession.shared
        session.dataTask(with: request) {  [weak self] (data, response, error) in
            guard let response = response as? HTTPURLResponse, response.statusCode == 201   else {
                DispatchQueue.main.async { self?.dismissLoadingAlertController() {_ in } }
                return
            }
            self?.fetchMemberProfile(tempS3key: signInModel.key ?? "", userName: self?.memberData?.name ?? "")
        }.resume()
    }
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
        
    }
    func createDataBody(withParameters params: [String:String]?, media: [Media]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value  + lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
}
extension EditProfileViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?, fileName: String?, imageType: String?) {
        self.profileImage.image = image
        //Call image SignIn Api
        if let name = fileName, let type =  imageType, let image = image  {
            self.isbackToPop = false
            self.imageSignIn(name: name, type: type, image: image)
        }
    }
}
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
