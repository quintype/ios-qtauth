//
//  QTButton.swift
//  QTAuth
//
//  Created by Benoy Vijayan on 18/10/19.
//  Copyright © 2019 Benoy Vijayan. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class QTRoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
}
