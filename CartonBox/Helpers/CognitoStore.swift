//
//  CognitoStore.swift
//  CartonBox
//
//  Created by kay weng on 09/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation
import AWSCognito
import AWSAuthCore
import FBSDKCoreKit

let CognitoStoreReceivedIdentityIdNotification: String = "CognitoStoreReceivedIdentityIdNotification"

class CognitoStore {

    let credentialsProvider: AWSCognitoCredentialsProvider
    let configuration: AWSServiceConfiguration
    
    init(provider: AWSIdentityProviderManager, token: String) {
        
        credentialsProvider = AWSCognitoCredentialsProvider(regionType: Constants.AWS_REGION,
                                                                identityPoolId: Constants.COGNITO_IDENTITY_POOL, identityProviderManager: provider)
        
        configuration = AWSServiceConfiguration(region: Constants.AWS_REGION, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    class func connectWithFacebook() -> CognitoStore?{
        
        if FacebookUser.sharedInstance.activeSession{
            
            let providerFacebook = CustomIdentityProvider(tokens: [AWSIdentityProviderFacebook: FBSDKAccessToken.current().tokenString])
            
            return CognitoStore(provider: providerFacebook, token: FBSDKAccessToken.current().tokenString)
        }
        
        return nil
    }
    
    func requestIdentity() {
        
        credentialsProvider.getIdentityId().continueWith() { (task) -> AnyObject! in
        
            if let error = task.error {
                print("Could not request identity:\(error.localizedDescription)")
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: CognitoStoreReceivedIdentityIdNotification), object: self, userInfo: ["identityId" : self.credentialsProvider.identityId!])
            }
            
            return nil
        }
    }
    
    func saveItem(dataset:String, key: String, value: String) {
        
        let client = AWSCognito.default()
        let dataSet: AWSCognitoDataset = client.openOrCreateDataset(dataset)
        dataSet.synchronize()
        
        dataSet.setString(value, forKey: key)
        dataSet.synchronize()
    }
    
    func loadInfo(dataset:String, callback: @escaping (_ tasks: Dictionary<String, String>) -> Void) {
        
        let client = AWSCognito.default()
        let dataSet: AWSCognitoDataset = client.openOrCreateDataset(dataset)
        
        dataSet.synchronize().continueWith { (task) -> AnyObject! in
            
            if let error = task.error {
                print("Could not sync data \(error.localizedDescription)")
            } else {
                callback(dataSet.getAll()! as Dictionary<String, String>)
            }
            
            return nil
        }
    }
}
