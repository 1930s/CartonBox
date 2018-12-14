//
//  FacebookViewModel.swift
//  CartonBox
//
//  Created by kay weng on 12/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import SnackKit
import AWSCognito

class FacebookSignInViewModel{
    
    var isLoading: ((Bool) -> ())?
    var onError: ((String) -> ())?
    var onDone: (() -> ())?
    
    var fb: FBSDKLoginManager!
    var activeSession: Bool{
        return FBSDKAccessToken.current() != nil
    }
    
    init() {
        self.fb = FBSDKLoginManager()
    }
    
    func loginFacebook(from controller:UIViewController, successBlock: @escaping SuccessBlock, andFailure failureBlock: @escaping FailureBlock){
        let facebookReadPermissions = ["public_profile", "email"]

        self.fb.logIn(withReadPermissions: facebookReadPermissions, from: controller) { (result, error) in
            guard let _ = result?.token.tokenString, error == nil else {
                self.logoutFacebook()
                failureBlock(error as NSError?)
                return
            }
            
            appDelegate.facebookUser = FacebookUser.currentUser()
            
            AmazonCognitoManager.shared.loginAmazonCognito(token: appDelegate.facebookUser!.tokenString, successBlock: { (result) in
                AmazonDynamoDBManager.shared.GetItem(User.self, hasKey: appDelegate.facebookUser!.userId, rangeKey: nil, completionHandler: { (result) in
                    
                    if let user = result as? User {
                        appDelegate.cartonboxUser = user
                    }else{
                        appDelegate.cartonboxUser = User()
                    }
                    
                    self.updateCartonBoxUserProfile(completion: { (error) in
                        if let _ = error{
                            self.logoutFacebook()
                            failureBlock(error)
                        }else{
                            successBlock(appDelegate.facebookUser!.tokenString)
                        }
                    })
                })
                
                UserActivityHelper.CreateFacebookLoginActivity(success: { (activity) in
                    
                }) { (error) in
                    //Log an error
                }
                
            }, andFailure: { (error) in
                self.logoutFacebook()
                failureBlock(error)
            })
        }
    }
    
    func logoutFacebook(){
        self.fb.logOut()
        appDelegate.facebookUser = nil
        appDelegate.cognitoUser = nil
    
        UserActivityHelper.CreateFacebookLogoutActivity(success: { (activity) in
            
        }) { (error) in
            //Log an error
        }
    }
    
    private func updateCartonBoxUserProfile(completion: AmazonClientCompletition?){
        if let _ = appDelegate.cartonboxUser, let _ = appDelegate.cartonboxUser!._userId{
            appDelegate.cartonboxUser?._modifiedOn = Date().now.toLocalString(DateFormat.dateTime)
        }else{
            appDelegate.cartonboxUser = User()
            appDelegate.cartonboxUser?._createdOn = Date().now.toLocalString(DateFormat.dateTime)
        }
        
        appDelegate.cartonboxUser?._userId = appDelegate.facebookUser!.userId
        appDelegate.cartonboxUser?._userName = appDelegate.facebookUser!.userName
        appDelegate.cartonboxUser?._active = NSNumber(value: true)
        
        AmazonDynamoDBManager.shared.SaveItem(appDelegate.cartonboxUser!) { (error:Error?) in
            completion?(error)
        }
    }
}
