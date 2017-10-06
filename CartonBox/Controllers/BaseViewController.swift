//
//  BaseViewController.swift
//  CartonBox
//
//  Created by kay weng on 04/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if !FacebookUser.sharedInstance.activeSession{
            
            let modalVC = sb.instantiateViewController(withIdentifier: "FacebookVC") as! FacebookViewController
            
            UIView.animate(withDuration: 1.5, animations: {
                self.present(modalVC, animated: true, completion: nil)
            })
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.UserProfileUpdated(notification:)),
                                               name:NSNotification.Name.FBSDKProfileDidChange,
                                               object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    @objc func UserProfileUpdated(notification: NSNotification)
    {
        //Update Cognito
        
        //Update DynamoDB
    }
}
