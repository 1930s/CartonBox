//
//  FacebookLoginCell.swift
//  CartonBox
//
//  Created by kay weng on 03/11/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit

protocol FacebookCellDelegate {
    
    func openFacebookLoginView()
}

let facebookCell = "FacebookCell"


class FacebookCell: UITableViewCell {

    @IBOutlet weak var btnLogout: UIButton!
    var delegate:FacebookCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onPressLogout(_ sender: Any) {
        self.delegate?.openFacebookLoginView()
    }
}
