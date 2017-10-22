//
//  Constants.swift
//  CartonBox
//
//  Created by kay weng on 05/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation
import AWSCore

typealias SuccessBlock = (Any?) -> ()
typealias FailureBlock = (Error?) -> ()
typealias CognitoBlock = (Error?) -> ()

public struct Constants{
    
    static let AWS_REGION = AWSRegionType.APSoutheast1
    
    static let FACEBOOK_APP_ID:String = "176173076266519"
    
    static let COGNITO_IDENTITY_POOL:String = "ap-southeast-1:1e2d47fd-b934-4509-820b-577648d1fbb5"
}
