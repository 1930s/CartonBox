//
//  AmazonSessionProvider.swift
//  CartonBox
//
//  Created by kay weng on 12/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation

extension Error {
    var infoMessage: String? {
        return (self as NSError).userInfo["message"] as? String
    }
}

protocol AmazonSessionProvider {
    /**
     Each entry in logins represents a single login with an identity provider.
     The key is the domain of the login provider (e.g. 'graph.facebook.com')
     and the value is the OAuth/OpenId Connect token that results from an authentication with that login provider.
     */
    func getSessionTokens(completition: @escaping (([String : String]?, Error?) -> ()))
    func isLoggedIn() -> Bool
    func logout()
}
