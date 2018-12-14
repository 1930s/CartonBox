//
//  Constants.swift
//  CartonBox
//
//  Created by kay weng on 05/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation
import AWSCore
import SnackKit

typealias SuccessBlock = (Any?) -> ()
typealias FailureBlock = (Error?) -> ()
typealias CognitoBlock = (Error?) -> ()

public struct AWSConfiguration{
    static var AWS_REGION = AWSRegionType.APSoutheast1
    
    static var CognitoIdentityPoolId:String {
        get{
            let credential =  appDelegate.awsConfiguration["CredentialsProvider"] as! JSON
            let cognitoIdentity = credential["CognitoIdentity"] as! JSON
            let _default = cognitoIdentity["Default"] as! JSON
            
            return _default["PoolId"] as! String
        }
    }
    
    static var FacebookAppId:String{
        get{
            let fbJson =  appDelegate.awsConfiguration["FacebookSignIn"] as! JSON
            let appId = fbJson["AppId"] as! String
            
            return appId
        }
    }
}

