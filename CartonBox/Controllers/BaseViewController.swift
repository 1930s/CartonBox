//
//  BaseViewController.swift
//  CartonBox
//
//  Created by kay weng on 04/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit
import SnackKit

let facebookVC = "FacebookVC"
let loadingVC = "LoadingVC"

class BaseViewController: UIViewController {

    lazy var facebookSigIn = sb.instantiateViewController(withIdentifier: facebookVC) as! FacebookSignInController
    lazy var loadingDisplay = sb.instantiateViewController(withIdentifier: loadingVC) as! LoadingController
    
    var tabController:UITabBarController!
    var isInternetAccess: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabController = appDelegate.window!.rootViewController as? UITabBarController
        
        self.setNotificationActions()
        
        self.initScreenSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Check Networking health
        self.checkNetworkHealth()
        
        guard self.isInternetAccess else {
            return
        }
        
        //Show facebook login if session is expired
        guard let _ = appDelegate.facebookUser, appDelegate.facebookUser!.activeSession else{
            
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
        appDelegate.facebookUser = FacebookUser.currentUser()
        self.updateFacebookUserInfo(info: notification.userInfo as! [String: AnyObject])
    }
    
    @objc func CognitoUserProfileUpdate(notification: NSNotification)
    {
        appDelegate.cognitoUser = CognitoUser.currentUser()
        self.updateCognitoUserInfo(info: notification.userInfo as! [String : AnyObject])
    }
    
    //MARK: - Methods
    public func initScreenSetting(){
        //override by subclass
    }
    
    public func updateFacebookUserInfo(info:[String: AnyObject]){
        //override by subclass
    }
    
    public func updateCognitoUserInfo(info:[String: AnyObject]){
        //override by subclass
    }
    
    public func enterForeground(){
        //override by subclass
    }
    
    public func isLoading(_ closure:@escaping ()->Bool){
        self.loadingDisplay.modalPresentationStyle = .overCurrentContext
        
        self.present(self.loadingDisplay, animated: true) {
            if closure(){
                self.loadingDisplay.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc fileprivate func willEnterForeground(){
        self.checkNetworkHealth()
        
        guard self.isInternetAccess else {
            return
        }
        
        self.enterForeground()
    }
    
    fileprivate func checkNetworkHealth(){
        if !NetworkHelper.isConnectedToNetwork(){
            
            let setting = UIAlertAction(title: "Setting", style: .destructive, handler: { (action) in
                UIApplication.shared.open(AppUrl.settingUrl!, options: [:], completionHandler: nil)
            })
            
            self.alert(title: Message.NoInternetConnect, message: Message.ConnectDeviceToInternet, style: .alert, actions: [setting])
            
            isInternetAccess = false
        }else{
            isInternetAccess = true
        }
    }
}

//MARK: - Extension
extension BaseViewController{
    
    func setNotificationActions(){
        //Facebook user info has been updated
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.FacebookUserProfileUpdate(notification:)), name:NSNotification.Name.FBSDKProfileDidChange, object: nil)
        
        //Cognito User info has been updated
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.CognitoUserProfileUpdate(notification:)), name: NSNotification.Name.AWSCognitoIdentityIdChanged, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
}
