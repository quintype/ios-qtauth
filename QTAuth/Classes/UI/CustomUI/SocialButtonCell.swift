//
//  SocialButtonCell.swift
//  QTAuth
//
//  Created by Benoy Vijayan on 21/10/19.
//  Copyright © 2019 Benoy Vijayan. All rights reserved.
//

import UIKit

class SocialButtonCell: UITableViewCell {

    @IBOutlet private weak var button: RoundButton!
    
    var icon: UIImage? {
        didSet {
            button.setImage(icon, for: .normal)
        }
    }
    
    var title: String? {
        didSet {
            button.setTitle(title, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
