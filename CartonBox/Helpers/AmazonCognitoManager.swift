//
//  AmazonClientManager.swift
//  CartonBox
//
//  Created by kay weng on 13/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation
import AWSCore
import AWSCognito
import AWSCognitoIdentityProvider
import UICKeyChainStore

let cognitoSyncKey = "cognitoSync"
let AmazonClientManagerDidLogoutNotification = Notification.Name("AmazonClientManagerDidLogoutNotification")
let KEYCHAIN_PROVIDER_KEY = "KEYCHAIN_PROVIDER_KEY"

typealias AmazonClientCompletition = ((Error?) -> ())

final class AmazonCognitoManager {
    
    private let keyChain: UICKeyChainStore!
    private var credentialsProvider: AWSCognitoCredentialsProvider?
    private var sessionProvider: AmazonSessionProvider?
    private let customIdentityProvider: CustomIdentityProvider!
    
    var currentIdentity: String? {
        return credentialsProvider?.identityId
    }
    
    class var shared: AmazonCognitoManager {
        
        struct Static {
            static var instance: AmazonCognitoManager? = nil
        }
        
        if Static.instance == nil{
            Static.instance = AmazonCognitoManager()
        }
        
        return Static.instance!
    }
    
    init() {
        
        self.keyChain = UICKeyChainStore(service: Bundle.main.bundleIdentifier!)
        self.customIdentityProvider = CustomIdentityProvider(tokens: nil)
  
        // Check if we have session indicator stored
        if self.keyChain[KEYCHAIN_PROVIDER_KEY] == AmazonSessionProviderType.FB.rawValue {
            sessionProvider = FBSessionProvider()
        }else{
            sessionProvider = nil
        }
    }
    
    // Tries to initiate a session with given session provider returns an error otherwise
    func login(sessionProvider: AmazonSessionProvider, completion: AmazonClientCompletition?) {
        self.sessionProvider = sessionProvider
        self.resumeSession(completion: completion)
    }
    
    // Tries to restore session or returns an error
    func resumeSession(completion: AmazonClientCompletition?) {
        if let sessionProvider = sessionProvider {
            sessionProvider.getSessionTokens() { [unowned self] (tokens, error) in
                
                guard let tokens = tokens, error == nil else {
                    completion?(error)
                    return
                }
                
                self.completeLogin(logins: tokens, completition: completion)
            }
        } else {
            completion?(AmazonSessionProviderErrors.RestoreSessionFailed)
        }
    }
    
    // Removes all associated session and cleans keychain
    func clearAll() {
        
        let cognito = AWSCognito(forKey: cognitoSyncKey)
        
        cognito.wipe()
        
        sessionProvider?.logout()
        keyChain.removeAllItems()
        credentialsProvider?.clearKeychain()
        credentialsProvider?.clearCredentials()
        sessionProvider = nil
        customIdentityProvider.tokens = nil
    }
    
    func logOut() {
        clearAll()
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: AmazonClientManagerDidLogoutNotification, object: nil)
        }
    }
    
    // Checks if we have logged in before
    func isLoggedIn() -> Bool {
        return sessionProvider?.isLoggedIn() ?? false
    }
    
    private func completeLogin(logins: [String : String]?, completition: AmazonClientCompletition?) {
        // Here we setup our default configuration with Credentials Provider, which uses our custom Identity Provider
        customIdentityProvider.tokens = logins
        self.credentialsProvider = AWSCognitoCredentialsProvider(regionType: AWSConfiguration.AWS_REGION, identityPoolId: AWSConfiguration.CognitoIdentityPoolId, identityProviderManager: customIdentityProvider)
        
        self.credentialsProvider?.getIdentityId().continueWith(block: { (task) -> Any? in
            
            if(task.error != nil){
                completition?(task.error)
            }else{
                let configuration = AWSServiceConfiguration(region: AWSConfiguration.AWS_REGION, credentialsProvider: self.credentialsProvider)
            
                AWSServiceManager.default().defaultServiceConfiguration = configuration
                AWSCognito.register(with: configuration!, forKey: cognitoSyncKey)
                
                completition?(nil)
            }
            
            return task
        })
    }
    
    func loginAmazonCognito(token:String, successBlock: @escaping SuccessBlock, andFailure failureBlock: @escaping FailureBlock){
        
        let fbSession = FBSessionProvider()
        
        AmazonCognitoManager.shared.login(sessionProvider: fbSession) { (error) in
            
            guard error == nil else{
                AmazonCognitoManager.shared.clearAll()
                failureBlock(error! as NSError)
                return
            }
            
            // Save & Sync user profile from CognitoSync storage
            CognitoUser.sync(completition: { (error) in
                
                guard error == nil else {
                    failureBlock(nil)
                    return
                }
                
                appDelegate.cognitoUser = CognitoUser.currentUser()
                appDelegate.cognitoUser?.userId = appDelegate.facebookUser?.userId
                appDelegate.cognitoUser?.name = appDelegate.facebookUser?.userName
                appDelegate.cognitoUser?.save(completition: { (error) in
                    
                    if let err = error {
                        failureBlock(err)
                    }else{
                        successBlock(nil)
                    }
                })
            })
        }
    }
}
