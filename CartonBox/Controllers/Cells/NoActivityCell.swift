//
//  NoActivityCell.swift
//  CartonBox
//
//  Created by kay weng on 06/11/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit

let noActivityCell = "NoActivityCell"

class NoActivityCell: UITableViewCell {

    @IBOutlet weak var lblMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
