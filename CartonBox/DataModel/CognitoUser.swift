//
//  CognitoUser.swift
//  CartonBox
//
//  Created by kay weng on 12/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation
import AWSCore
import AWSCognito
import AWSAuthCore

internal let cognitoSyncDataset = "userProfile"

final class CognitoUser {
    
    var userId: String?
    var name: String?
    var lastSyncOn: String?
    var identityId: String?
    
    init() {
        
    }
}

extension CognitoUser {
    // Save all user's data to CognitoSync
    
    func save(completition: AmazonClientCompletition?) {
        // openOrCreateDataset - creates a dataset if it doesn't exists or open existing
        let dataset = AWSCognito(forKey: cognitoSyncKey).openOrCreateDataset(cognitoSyncDataset)
        
        dataset.setString(userId, forKey: "userId")
        dataset.setString(name, forKey: "name")
        dataset.setString(Date().now.toLocalString("dd/MM/yyyy hh:mm:ss a"), forKey: "lastSyncOn")
        dataset.setString(AWSIdentityManager.default().identityId!, forKey: "identityId")
        
        CognitoUser.sync(completition: completition)
    }
    
    static func sync(completition: AmazonClientCompletition?) {
        // openOrCreateDataset - creates a dataset if it doesn't exists or open existing
        let dataset = AWSCognito(forKey: cognitoSyncKey).openOrCreateDataset(cognitoSyncDataset)
        // synchronize is going to:
        // 1) Fetch from AWS, if there were any changes
        // 2) Upload local changes to AWS
        dataset.synchronize().continueWith(block: { (task) -> Any? in
            completition?(task.error)
        })
    }
    
    static func currentUser(firstName: String? = nil, lastName: String? = nil) -> CognitoUser {
        
        let dataset = AWSCognito(forKey: cognitoSyncKey).openOrCreateDataset(cognitoSyncDataset)
        let user = CognitoUser()
        
        user.userId = dataset.string(forKey: "userId")
        user.name = dataset.string(forKey:"name")
        user.lastSyncOn = dataset.string(forKey: "lastSyncOn")
        user.identityId = dataset.string(forKey: "identityId")
        
        return user
    }
}
