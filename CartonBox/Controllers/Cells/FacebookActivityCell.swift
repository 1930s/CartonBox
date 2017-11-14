//
//  FacebookActivityCell.swift
//  CartonBox
//
//  Created by kay weng on 06/11/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit

let facebookActivityCell = "FacebookActivityCell"

class FacebookActivityCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var lblTimeStamp: UILabel!
    @IBOutlet weak var constMessageBottom: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
