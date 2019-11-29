//
//  QTLoginViewController.swift
//  QTAuth
//
//  Created by Benoy Vijayan on 21/10/19.
//  Copyright © 2019 Benoy Vijayan. All rights reserved.
//

import UIKit

class QTLoginViewController: UIViewController {
    
    @IBOutlet private weak var loginGoogleButton: RoundButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        
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

}

extension QTLoginViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return QTAuth.instance.config?.authProviders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoginCell") as! SocialButtonCell
        
        let provider = QTAuth.instance.config?.authProviders?[indexPath.row]
        cell.icon = provider?.logo
        cell.title = provider?.buttonTitle
        
        return cell
    }
    
    
}
