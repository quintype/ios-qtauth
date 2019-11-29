//
//  QTSignupViewController.swift
//  QTAuth
//
//  Created by Benoy Vijayan on 23/10/19.
//  Copyright © 2019 Benoy Vijayan. All rights reserved.
//

import UIKit


class QTSignupViewController: QTViewController {

    private var emailAuth: QTEmailAuth!
    override func viewDidLoad() {
        super.viewDidLoad()

        emailAuth = QTEmailAuth()
        // Do any additional setup after loading the view.
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
        let request = QTAuthSignupRequest(name: "Rakshith6", email: "rakshith+16@quintype.com", username: "rakshith", password: "password")
        emailAuth.signup(with: request, callback: { data , error in
            
            if error == nil {
                
            }
            
        })
    }
    

}
