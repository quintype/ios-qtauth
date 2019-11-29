//
//  QTLoginViewController.swift
//  QTAuth
//
//  Created by Benoy Vijayan on 21/10/19.
//  Copyright © 2019 Benoy Vijayan. All rights reserved.
//

import UIKit

public class QTLoginViewController: QTViewController {
    
    private var fbAuth: QTFBAuth!
    private var gAuth: QTGAuth!
    private var ttrAuth: QTTtrAuth!
    private var liAuth: QTLIAuth!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        fbAuth = QTFBAuth(vc: self)
        gAuth = QTGAuth(vc: self)
        ttrAuth = QTTtrAuth(vc: self)
        liAuth = QTLIAuth(vc: self)
    }
    
    private func takeAction(for provider: QTAuthProvider?) {
        
        switch provider ?? QTAuthProvider.email {
        case .email:
            let storyBoard : UIStoryboard = UIStoryboard(name: "QTAuth", bundle: bundle)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginWithEmailScene") as! QTEmailLoginViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        case .facebook:
            fbAuth.fbLogin()
        case .google:
            gAuth.signin()
        case .twitter:
            ttrAuth.login()
        case .linkedIn:
            liAuth.login()
        }
        
    }
}

extension QTLoginViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authConfig.authProviders?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoginCell") as! QTSocialButtonCell
        cell.provider = authConfig.authProviders?[indexPath.row]
        cell.didTapButton = { [weak self] provider in
            self?.takeAction(for: provider)
        }
        return cell
    }
}
