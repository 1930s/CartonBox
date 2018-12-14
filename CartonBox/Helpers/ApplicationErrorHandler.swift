//
//  ApplicationErrorHandler.swift
//  CartonBox
//
//  Created by kay weng on 02/03/2018.
//  Copyright © 2018 kay weng. All rights reserved.
//

import Foundation

class ApplicationErrorHandler{
    
    static func retrieveApplicationErrorMessage(code:Int)->String{
       
        var errorMessage = ""
        
        if let eenum = ApplicationError(rawValue: code){
            switch eenum {
            case .ExceedMaxFileSize:
                errorMessage = "Selected file exceeded maximum file size support"
                break
            case .LostFacebookSession:
                errorMessage = "Facebook session timeout.Please login again"
                break
            case .NoConnection:
                errorMessage = "No internet connection"
                break
            case .Timeout15s:
                errorMessage = "Timeout for 15 seconds"
                break
            case .Timeout30s:
                errorMessage = "Timeout for 30 seconds"
                break
            case .UnknownError:
                errorMessage = "An application error was occured"
                break
            }
        }
        
        return errorMessage
    }
}
