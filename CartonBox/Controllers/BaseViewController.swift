//
//  BaseViewController.swift
//  CartonBox
//
//  Created by kay weng on 04/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var facebookUser:FacebookUser?
    var cognitoUser:CognitoUser?
    
    let facebookSigIn = sb.instantiateViewController(withIdentifier: "FacebookVC") as! FacebookSignInController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.facebookUser = FacebookUser.currentUser()
        self.cognitoUser = CognitoUser.currentUser()
        
        setNotificationActions()
        
        self.initScreenSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        guard let _ = self.facebookUser, self.facebookUser!.activeSession else{
            UIView.animate(withDuration: 1.5, animations: {
                self.present(self.facebookSigIn, animated: true, completion: nil)
            })
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    @objc func FacebookUserProfileUpdate(notification: NSNotification)
    {
        self.facebookUser = FacebookUser.currentUser()
        self.updateFacebookUserInfo(info: notification.userInfo as! [String: AnyObject])
    }
    
    @objc func CognitoUserProfileUpdate(notification: NSNotification)
    {
        self.cognitoUser = CognitoUser.currentUser()
        self.updateCognitoUserInfo(info: notification.userInfo as! [String : AnyObject])
    }
    
    public func initScreenSetting(){
        //override by subclasss; this function should be empty content
    }
    
    public func updateFacebookUserInfo(info:[String: AnyObject]){
        //override by subclasss; this function should be empty content
    }
    
    public func updateCognitoUserInfo(info:[String: AnyObject]){
        
//        viewModel.SaveUserDetail(user, completion: { (saved, message) in
//
//            if saved{
//                self.vwFBUserProfile.profileID = self.facebookUser!.userID
//                self.lblUserName.text = self.facebookUser!.userName
//            }else{
//                self.vwFBUserProfile.profileID = ""
//                self.lblUserName.text = "Anonymous"
//            }
//        })
    }
}

extension BaseViewController{
    
    func setNotificationActions(){
        //Facebook user info has been updated
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.FacebookUserProfileUpdate(notification:)), name:NSNotification.Name.FBSDKProfileDidChange, object: nil)
        
        //Cognito User info has been updated
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.CognitoUserProfileUpdate(notification:)),
                                               name: NSNotification.Name.AWSCognitoIdentityIdChanged, object: nil)
    }
}
