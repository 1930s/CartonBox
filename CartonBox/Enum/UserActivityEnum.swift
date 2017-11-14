//
//  UserActivityEnum.swift
//  CartonBox
//
//  Created by kay weng on 04/11/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation

enum UserAcitvityEnum: String{
    
    case FacebookLogin =  "Facebook Login"
    case FacebookLogout = "Facebook Logout"
}

enum UserActivityMessageEnum: String{
    
    case Login = "You have been login with facebook account"
    case Logout = "You have been logout with facebook account"
}

enum UserActivityStatusEnum: Int{
    
    case New = 1
    case Read = 2
    case Unread = 3
    case Disposed = 9
}
