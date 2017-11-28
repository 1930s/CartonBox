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
    
    static var FacebookSignIn:String{
        
        get{
            do {
                let fbJson =  appDelegate.awsConfiguration["FacebookSignIn"]
                let data = fbJson??.data(using: .utf8)
                
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]{
                    return json["AppId"] as! String
                }
            }catch let error as NSError{
                print(error)
            }
            
            return ""
        }
    }
    
    static var COGNITO_IDENTITY_POOL:String = "ap-southeast-1:94c56cd4-6e19-4015-9daa-899835db44e4"
}
