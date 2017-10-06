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
    
    var fbManager:FBSDKLoginManager!
    
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
    }
    
    //MARK: - Actions
    func loginFacebook(controller:UIViewController,
                       permissions:[String] = ["public_profile", "email", "user_friends"],
                       completion:@escaping (_ result:FBSDKLoginManagerLoginResult?)->Void){

        fbManager.logIn(withReadPermissions: permissions, from: controller) { (loginResult, error) in
            
            if(error != nil){
                
                NSLog("An error is occurred !")
                completion(nil)
                
            }else if let _ = loginResult, loginResult!.isCancelled{
                
                NSLog("Cancelled")
                self.fbManager.logOut()
                completion(nil)
                
            }else{
            
                if let _ = FBSDKAccessToken.current(), let _ = FBSDKAccessToken.current().tokenString{
                    FBSDKProfile.enableUpdates(onAccessTokenChange: true)
                }
                
                completion(loginResult)
            }
        }
    }
    
    func logoutFacebook(){
        fbManager.logOut()
    }

//Todo:
//    func fetchUserFacebookData(param:String = "id, name, first_name, last_name, picture.type(small),email",
//                               completion:@escaping (_ data:[String:AnyObject]?)->Void){
//
//        var dict:[String:AnyObject] = [:]
//
//        if((FBSDKAccessToken.current()) != nil){
//
//            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": param])
//            let arr = (param.characters.split{$0 == ","}.map(String.init))
//
//            graphRequest.start(completionHandler: { (connection, result, error) -> Void in
//
//                if (error != nil){
//                    NSLog("An error is occurred !")
//                    completion(nil)
//                }else{
//
//                    for var p in arr {
//                        dict[p] = String(result.objectForKey(p)!)
//                    }
//
//                    completion(dict)
//                }
//            })
//        }
//    }
    
}
