//
//  ApplicationErrorEnum.swift
//  CartonBox
//
//  Created by kay weng on 27/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation

//error code : 0000
enum ApplicationError: Int {
    
    case NoConnection = 0001
    case Timeout15s = 0002
    case Timeout30s = 0003
    case LostFacebookSession = 0004
    case UnknownErro = 9999
}
