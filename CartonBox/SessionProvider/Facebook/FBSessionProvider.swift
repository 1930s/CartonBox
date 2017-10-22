//
//  FBSessionProvider.swift
//  CartonBox
//
//  Created by kay weng on 12/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation
import AWSCore
import AWSCognito
import AWSCognitoIdentityProvider
import FBSDKCoreKit
import FBSDKLoginKit
import UICKeyChainStore

let COGNITO_FB_PROVIDER = "graph.facebook.com"
let FB_SDK_PROFILE_OLD = "FBSDKProfileOld"
let FB_SDK_PROFILE_NEW = "FBSDKProfileNew"

final class FBSessionProvider: AmazonSessionProvider {
    
    private let keyChain: UICKeyChainStore!
    
    init() {
        keyChain = UICKeyChainStore(service: Bundle.main.bundleIdentifier!)
    }
    
    func getSessionTokens(completition: @escaping (([String : String]?, Error?) -> ())) {
        
        guard FBSDKAccessToken.current() != nil else {
            completition(nil, AmazonSessionProviderErrors.LoginFailed)
            return
        }
        
        keyChain[KEYCHAIN_PROVIDER_KEY] = AmazonSessionProviderType.FB.rawValue
        completition([COGNITO_FB_PROVIDER : FBSDKAccessToken.current().tokenString], nil)
    }
    
    func isLoggedIn() -> Bool {
        return FBSDKAccessToken.current() != nil
    }
    
    func logout() {
        FBSDKLoginManager().logOut()
    }
}
