//
//  AppFormat.swift
//  
//
//  Created by kay weng on 27/10/2017.
//

import Foundation
import UIKit

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
        
        var countries:[String] = []
        
        for code in NSLocale.isoCountryCodes as [String] {
            
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            
            if let name = NSLocale(localeIdentifier: "en_us").displayName(forKey: NSLocale.Key.identifier, value: id) {
                countries.append(name)
            }
        }
        
        return countries
    }
    
    static func getGenderList()->[String]{
        return ["Male","Female"]
    }
}

public struct AppUrl{
    
    static let settingUrl = URL(string: UIApplicationOpenSettingsURLString)
}

