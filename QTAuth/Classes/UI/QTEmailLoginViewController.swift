//
//  EmailLoginViewController.swift
//  QTAuth
//
//  Created by Benoy Vijayan on 23/10/19.
//  Copyright © 2019 Benoy Vijayan. All rights reserved.
//

import UIKit

public class QTEmailLoginViewController: QTViewController {

    private var emailAuth: QTEmailAuth!
    private var apiManager: AuthAPIManager!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        emailAuth = QTEmailAuth()
        apiManager = AuthAPIManager()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction private func didTapContinue(button: QTRoundButton) {
//        emailAuth.login(with: "sharath.m+1@quintype.com",
//                        password: "asdf",
//                        callback: { data, error in
//
//
//
//        })
        
        apiManager.signIn(email: "sharath.m+1@quintype.com", password: "asdf") { (response, error) in
            guard let member = response?.member, error == nil else { return }
            print(String(describing: member))
        }
        
    }

}
