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
    var userId:String {
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

    init() { }
}

extension FacebookUser{
    
    static func currentUser()->FacebookUser?{
        
        let user = FacebookUser()
        
        guard user.activeSession else {
            return nil
        }
        
        return user
    }
}
