//
//  FacebookUserViewModel.swift
//  CartonBox
//
//  Created by kay weng on 02/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import SnackKit
import AWSCognito

public class FacebookUser{
    
    //MARK: - Property
    var userID:String {
        return FBSDKProfile.current() == nil ? "" : FBSDKAccessToken.current().userID
    }
    
    var userName:String{
        return FBSDKProfile.current() == nil ? "" : FBSDKProfile.current().name
    }
    
    var appID:String{
        return FBSDKAccessToken.current() == nil ? "" : FBSDKAccessToken.current().appID
    }
    
    var tokenString:String{
        return FBSDKAccessToken.current() == nil ? "" : FBSDKAccessToken.current().tokenString
    }
    
    var activeSession:Bool{
        return FBSDKAccessToken.current() != nil
    }
    
    var cognitoId:String?
    
    var fbManager:FBSDKLoginManager!
    var cognitoStore:CognitoStore?
    
    class var sharedInstance: FacebookUser {
        
        struct Static {
            static var instance: FacebookUser? = nil
        }
        
        if Static.instance == nil{
            Static.instance = FacebookUser()
        }
        
        return Static.instance!
    }
    
    //MARK: - Initialization
    public init() {
        
        self.fbManager = FBSDKLoginManager()
        
        NotificationCenter.default.addObserver(self, selector: #selector(FacebookUser.onProfileUpdated(notification:)), name:NSNotification.Name.FBSDKProfileDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(FacebookUser.onReceiveIdentityId(notification:)), name: NSNotification.Name(rawValue: CognitoStoreReceivedIdentityIdNotification), object: nil)
    }
    
    //MARK: - Actions
    func loginFacebook(controller:UIViewController,
                       permissions:[String] = ["public_profile", "email", "user_friends"],
                       completion:@escaping (_ result:FBSDKLoginManagerLoginResult?)->Void){

        fbManager.logIn(withReadPermissions: permissions, from: controller) { (loginResult, error) in
            
            if(error != nil){
                
                NSLog("An error is occurred !")
                
            }else if let _ = loginResult, loginResult!.isCancelled{
                
                NSLog("Cancelled")
                self.fbManager.logOut()

            }else if let _ = FBSDKAccessToken.current(), let _ = FBSDKAccessToken.current().tokenString{
                
                    FBSDKProfile.enableUpdates(onAccessTokenChange: true)
            
                    completion(loginResult)
                    
                    return
            }
            
            completion(nil)
        }
    }
    
    func logoutFacebook(){
        fbManager.logOut()
    }

    @objc func onProfileUpdated(notification: NSNotification)
    {
        cognitoStore = CognitoStore.connectWithFacebook()
        
        self.cognitoStore?.requestIdentity()
    }
    
    @objc func onReceiveIdentityId(notification: NSNotification)
    {
        self.cognitoId = notification.userInfo?["identityId"] as? String

        self.cognitoStore?.saveItem(dataset: "UserInfo", key: "Id", value: self.userID)
        self.cognitoStore?.saveItem(dataset: "UserInfo", key: "Name", value: self.userName)
        self.cognitoStore?.saveItem(dataset: "UserInfo", key: "IdentityId", value: self.cognitoId ?? "")
    }
}
