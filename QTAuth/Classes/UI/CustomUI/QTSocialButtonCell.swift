//
//  SocialButtonCell.swift
//  QTAuth
//
//  Created by Benoy Vijayan on 21/10/19.
//  Copyright © 2019 Benoy Vijayan. All rights reserved.
//

import UIKit

class QTSocialButtonCell: UITableViewCell {

    @IBOutlet private weak var button: QTRoundButton!
    
    var didTapButton: (QTAuthProvider?) -> Void = { _ in }
    var provider: QTAuthProvider? {
        didSet {
            button.setImage(provider?.logo, for: .normal)
            button.setTitle(provider?.buttonTitle, for: .normal)
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
    
    @IBAction private func didTap(button: QTRoundButton) {
        didTapButton(provider)
    }

}
