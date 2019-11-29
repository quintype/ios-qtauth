//
//  QTViewController.swift
//  Pods-QTAuth_Example
//
//  Created by Benoy Vijayan on 23/10/19.
//

import UIKit

public class QTViewController: UIViewController {

    @IBOutlet private weak var logoView: UIImageView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        logoView.image = getAppImage(with: authConfig.logo ?? "qt-logo")
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
