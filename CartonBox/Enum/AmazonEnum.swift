//
//  AmazonEnum.swift
//  CartonBox
//
//  Created by kay weng on 15/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation

enum AmazonSessionProviderErrors: Error {
    case RestoreSessionFailed
    case LoginFailed
}

enum AmazonSessionProviderType: String {
    case FB, USERPOOL
}
