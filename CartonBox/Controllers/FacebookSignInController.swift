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

class FacebookSignInController: BaseViewController {

    @IBOutlet weak var vwLoginInfo: UIView!
    @IBOutlet weak var pgLoginInfo: UIPageControl!
    @IBOutlet weak var lblLoginInfo: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var pgFacebookInfo: UIPageControl!
    
    var viewModel: FacebookSignInViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = FacebookSignInViewModel()
        
        self.updateLoginScreenText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closeFacebookLogin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        
       super.isLoading { () -> Bool in
         
            if self.viewModel.activeSession{
                self.viewModel.logoutFacebook()
                self.updateLoginScreenText()
                
            }else{
                self.viewModel.loginFacebook(from: self, successBlock: { (result) in
                    self.dismiss(animated: true, completion: nil)
                    self.updateLoginScreenText()
                }, andFailure: { (error) in
                    self.alert(title: "Login Failed", message: "Please try again")
                })
            }
        
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! ContainerController
        
        destination.containerParent = self
    }
    
}

extension FacebookSignInController{
    
    func updateLoginScreenText(){
        
        self.btnLogin.layer.cornerRadius = CGFloat(20.0)
        
        self.lblLoginInfo.text = self.viewModel.activeSession ?
            "You already logged in" : "You are not logged in yet"
        
        self.btnLogin.setTitle(self.viewModel.activeSession ?
            "Logout Facebook" : "Login with Facebook", for: UIControlState.normal)
        
        if let _ = appDelegate.facebookUser, appDelegate.facebookUser!.activeSession{
            self.btnClose.isHidden = false
        }else{
            self.btnClose.isHidden = true
        }
    }
}
