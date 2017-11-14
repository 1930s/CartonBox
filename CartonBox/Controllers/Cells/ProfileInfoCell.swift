//
//  ProfileInfoCell.swift
//  CartonBox
//
//  Created by kay weng on 29/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit

let profileInfoCell = "ProfileInfoCell"

class ProfileInfoCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var txtInfo: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
