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
    
    var vm:FacebookSignInViewModel = FacebookSignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setLoginInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Actions
    @IBAction func closeFacebookLogin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        
       super.isLoading { () -> Bool in
         
            if self.vm.activeSession{
                self.vm.logoutFacebook()
                self.setLoginInfo()
                
            }else{
                self.vm.loginFacebook(from: self, successBlock: { (result) in
                    self.dismiss(animated: true, completion: nil)
                    self.setLoginInfo()
                }, andFailure: { (error) in
                    self.alert(title: "Login Failed", message: "Please try again")
                })
            }
        
            return true
        }
    }
    
    //MARK: - Methods
    fileprivate func setLoginInfo(){
        
        self.lblLoginInfo.text = self.vm.activeSession ?
            "You already logged in" : "You are not logged in yet"
        
        self.btnLogin.layer.cornerRadius = CGFloat(20.0)
        self.btnLogin.setTitle(self.vm.activeSession ?
            "Logout Facebook" : "Login with Facebook", for: UIControlState.normal)
        
        if let _ = appDelegate.facebookUser{
            self.btnClose.isHidden = appDelegate.facebookUser!.activeSession
        }else{
            btnClose.isHidden = false
        }
    }
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! ContainerController
        
        destination.containerParent = self
    }
    
}
