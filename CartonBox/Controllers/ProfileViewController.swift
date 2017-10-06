//
//  ProfileViewController.swift
//  CartonBox
//
//  Created by kay weng on 01/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class ProfileViewController: BaseViewController {

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var vwFBUserProfile: FBSDKProfilePictureView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.vwFBUserProfile.circle()
        
        if FacebookUser.sharedInstance.activeSession{
            
            self.vwFBUserProfile.profileID = FacebookUser.sharedInstance.userID
            self.lblUserName.text = FacebookUser.sharedInstance.userName
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.onProfileUpdated(notification:)),
                                               name:NSNotification.Name.FBSDKProfileDidChange,
                                               object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func openFacebookLogin(_ sender: Any) {
    
        let modalVC = sb.instantiateViewController(withIdentifier: "FacebookVC") as! FacebookViewController
        
        self.present(modalVC, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    @objc func onProfileUpdated(notification: NSNotification)
    {
        self.vwFBUserProfile.profileID = FacebookUser.sharedInstance.activeSession ? FacebookUser.sharedInstance.userID : ""
        self.lblUserName.text = FacebookUser.sharedInstance.activeSession ? FacebookUser.sharedInstance.userName : "Anonymous"
    }
}
