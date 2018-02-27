//
//  MobileCell.swift
//  CartonBox
//
//  Created by kay weng on 27/12/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit

let mobileCell = "MobileCell"

class MobileCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblMobileCountryCode: UILabel!
    @IBOutlet weak var txtInfo: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.txtInfo.keyboardType = .phonePad
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
