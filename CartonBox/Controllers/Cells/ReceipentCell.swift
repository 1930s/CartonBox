//
//  ReceipentCell.swift
//  CartonBox
//
//  Created by kay weng on 21/11/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit

let receipentCell = "ReceipentCell"

class ReceipentCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblReceipentEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
