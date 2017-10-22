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
    
    var fb:FBSDKLoginManager!
    var cognitoUser:CognitoUser?
    var facebookUser:FacebookUser?
    
    var activeSession:Bool{
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
            
            self.facebookUser = FacebookUser.currentUser()
            
            self.loginAmazonCognito(token: self.facebookUser!.tokenString, successBlock: { (result) in
                
                self.SaveUserDetail(completion: { (error) in
                    
                    if let _ = error{
                        self.logoutFacebook()
                        failureBlock(error)
                    }else{
                        successBlock(self.facebookUser!.tokenString)
                    }
                })
                
            }, andFailure: { (error) in
                self.logoutFacebook()
                failureBlock(error)
            })
        }
    }
    
    func logoutFacebook(){
        self.fb.logOut()
        self.facebookUser = nil
        self.cognitoUser = nil
        
        //Todo: create fb logout activity
    }
    
    private func loginAmazonCognito(token:String, successBlock: @escaping SuccessBlock, andFailure failureBlock: @escaping FailureBlock){
        
        let fbSession = FBSessionProvider()

        AmazonCognitoManager.sharedInstance.login(sessionProvider: fbSession) { (error) in
         
            guard error == nil else{
                AmazonCognitoManager.sharedInstance.clearAll()
                failureBlock(error! as NSError)
                return
            }
            // Save & Sync user profile from CognitoSync storage
            CognitoUser.sync(completition: { (error) in
                
                guard error == nil else {
                    failureBlock(nil)
                    return
                }
                
                self.cognitoUser = CognitoUser.currentUser()
                
                self.cognitoUser?.userId = self.facebookUser?.userID
                self.cognitoUser?.name = self.facebookUser?.userName
                self.cognitoUser?.save(completition: { (error) in
                    
                    if let err = error {
                        failureBlock(err)
                    }else{
                        successBlock(nil)
                    }
                })
            })
        }
    }
    
    private func SaveUserDetail(completion: AmazonClientCompletition?){
        
        let user:CartonBoxUser = CartonBoxUser()
        user.UserId = self.facebookUser!.userID
        user.Name = self.facebookUser!.userName
        
        AmazonDynamoDBManager.sharedInstance.SaveItem(user) { (error:Error?) in
            completion?(error)
        }
    }
}
