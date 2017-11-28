//
//  AppFormat.swift
//  
//
//  Created by kay weng on 27/10/2017.
//

import Foundation
import UIKit

public struct ControllerName{
    
    static let CommonPicker = "CommonPickerVC"
    static let DatePickerVC = "DatePickerVC"
    static let ProfileVC = "ProfileVC"
}

public struct Message{
    
    static let Anonymous = "Anonymous"
    
    static let Application = "Application"
    static let Info = "Infomation"
    static let Warning = "Warning"
    static let Error = "Error"
    
    static let ReLogin = "Invalid User Info.Please re-login."
    //static let IncompleteProfileInfo = "Your profile is incomplete. \nPlease fill in all info"
    static let RequiredProfileInfo = "Application requires a complete profile. \nPlease fill in all info and save your profile"
    static let InvalidDOB = "Please select your date of birth"
    static let InvalidEmail = "Pleasse enter your email address \nE.g: cartonbox@mail.com"
    static let InvalidMobile = "Pleasse enter your mobile number \nE.g: 0123456789"
    static let InvalidGender = "Please select your gender"
    static let InvalidCountry = "Please select your natinality"
}

public struct DateFormat {
    
    static let dayMonth = "dd MMM"
    
    static let dateTime = "dd/MM/yyyy hh:mm:ss a"
    
    static let dateOnly = "dd/MM/yyyy"
    
    static let dateBeautify = " dd MMM yyyy"
    
    static let time = "hh:mm:ss a"
    
    static let dayName = "EEEE"
    
    static let weekdayWithTime = "EEEE, hh:mm:ss a"
    
    static func GetDate(from dateString:String)->Date?{
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yyyy hh:mm:ss a"
        dateformatter.timeZone = NSTimeZone.local

        return dateformatter.date(from: dateString)
    }
}

public struct Parameters{
    
    static func getAllCountries()->[String]{
        
        let countries:[String] = ["Malaysia","Singapore"]
        //TODO: support all countries
//        for code in NSLocale.isoCountryCodes as [String] {
//
//            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
//
//            if let name = NSLocale(localeIdentifier: "en_us").displayName(forKey: NSLocale.Key.identifier, value: id) {
//                countries.append(name)
//            }
//        }
        
        return countries
    }
    
    static func getGenderList()->[String]{
        return ["Male","Female"]
    }
}

public struct AppUrl{
    
    static let settingUrl = URL(string: UIApplicationOpenSettingsURLString)
}

