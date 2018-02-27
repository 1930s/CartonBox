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
    static let SearchContactVC = "SearchContactVC"
    static let PhotoViewerVC = "PhotoViewerVC"
    static let PHPageViewVC  = "PHPageViewVC"
    static let VideoViewerVC = "VideoViewerVC"
}

public struct Message{
    
    static let Anonymous = "Anonymous"
    
    static let Application = "Application"
    static let Info = "Infomation"
    static let Warning = "Warning"
    static let Error = "Error"
    static let TimeOut = "Time Out"
    
    static let SavedProfile = "Your profile have been successfully updated"
    static let RequiredProfileInfo = "Application need your completed profile information to better identify your needs and serve you"
    static let InvalidDOB = "Please select a date of birth"
    static let InvalidEmail = "Pleasse enter a valid email address \nExample: cartonbox@mail.com"
    static let InvalidMobile = "Pleasse enter a valid mobile number \nExample: +60 123456789"
    static let InvalidGender = "Please select a gender"
    static let InvalidCountry = "Please select a nationality"
    static let NoInternetConnect = "No Internet Connection"
    static let RequiredReceipent = "Please add one or many receipent(s)"
    
    static let NewBoxMandatory = "You must provide a title and one or many receipent(s)"
    
    static let CannotLoadVideo = "Cannot load video"
    static let CannotLoadImage = "Cannot load image"

    static let PhotoLoadTimeout = "Timeout loading photo from iCloud.Would you like to reload the photo?"
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
    
    static func getMobileCountryCode(_ country:String)->String{
        
        var countryCode = ""
        
        switch country {
        case "Singapore":
            countryCode = "+65"
        case "Malaysia":
            countryCode = "+60"
        default:
            countryCode = ""
        }
        
        return countryCode
    }
}

public struct AppUrl{
    
    static let settingUrl = URL(string: UIApplicationOpenSettingsURLString)
}

