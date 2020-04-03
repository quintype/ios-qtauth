//
//  AuthBaseViewController.swift
//  QTAuth
//
//  Created by Maulik Sharma on 23/12/19.
//

import UIKit

class AuthBaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    public func presentLoadingAlertController(message: String? = "Please wait...", animated: Bool = false, completion:(() -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.color = UIColor.init(fromHex: "#f4511e")
        loadingIndicator.startAnimating();
        alertController.view.addSubview(loadingIndicator)
        self.present(alertController, animated: animated, completion: completion)
    }
    
    func dismissLoadingAlertController(completion: @escaping (_ iscomplete: Bool?) -> Void)  {
        if let controller = self.presentedViewController, controller is UIAlertController {
            self.dismiss(animated: false) {
                completion(true)
            }
        }
    }
    func popAuthViewControllers() {
        guard let viewControllers = self.navigationController?.viewControllers else { return }
        for viewController in viewControllers.reversed() {
            if !(viewController is AuthBaseViewController) {
                navigationController?.popToViewController(viewController, animated: true)
                break
            }
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
