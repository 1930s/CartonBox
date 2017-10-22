//
//  FacebookPageInfo1Controller.swift
//  CartonBox
//
//  Created by kay weng on 10/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit
import SnackKit

class FacebookPageInfo1Controller: UIViewController {

    @IBOutlet weak var imgFbInfo: UIImageView!
    @IBOutlet weak var txtFbInfo: UITextView!
    
    var root:UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgFbInfo.corner(rounding: UIRectCorner.allCorners, size: CGSize(width: 10, height: 10))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
