//
//  FacebookViewController.swift
//  CartonBox
//
//  Created by kay weng on 02/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit
import SnackKit
import FBSDKCoreKit
import FBSDKLoginKit

class FacebookViewController: UIViewController {

    @IBOutlet weak var vwLoginInfo: UIView!
    @IBOutlet weak var pgLoginInfo: UIPageControl!
    @IBOutlet weak var lblLoginInfo: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnLogin.layer.cornerRadius = CGFloat(20.0)
        self.updateLoginScreenText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.btnClose.isHidden = !FacebookUser.sharedInstance.activeSession
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closeFacebookLogin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        
        if FacebookUser.sharedInstance.activeSession{
            FacebookUser.sharedInstance.logoutFacebook()
        }else{
            FacebookUser.sharedInstance.loginFacebook(controller: self, completion: { (result) in

                if let _ = result{
                    self.dismiss(animated: true, completion: nil)
                }else{
                    self.alert(title: "Login Failed", message: "Invalid Facebook login")
                }
            })
        }
        
        self.updateLoginScreenText()
    }
    
    // MARK: - Action
    func updateLoginScreenText(){
        
        self.lblLoginInfo.text = FacebookUser.sharedInstance.activeSession ?
            "You already logged in" : "You are not logged in yet"

        self.btnLogin.setTitle(FacebookUser.sharedInstance.activeSession ?
            "Logout Facebook" : "Login with Facebook", for: UIControlState.normal)
    }
}
