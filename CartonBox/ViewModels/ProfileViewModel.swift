//
//  ProfileViewModel.swift
//  CartonBox
//
//  Created by kay weng on 12/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation

typealias ProfileCellInfo = (tag:Int, iconName:String, data:String?, placeholder:String?)

class ProfileViewModel{
    
    var user:User?{
        return appDelegate.cartonboxUser
    }
    
    let arrCell = ["Birthday", "Gender","Email", "Mobile","Nationality"]
    
    init() {
    
    }
    
    func getUserCellInfo(type:String)->ProfileCellInfo{
        
        switch type {
        case "Email":
            return (3,"Email", self.user?._email, "Enter your email address")
        case "Birthday":
            return (1,"Cake",self.user?._dob, "Select your Birthday date")
        case "Gender":
            return (2,"Unknown",self.user?._gender, "Select your Gender")
        case "Mobile":
            return (4,"Mobile",self.user?._mobile, "Enter your mobile number")
        case "Nationality":
            return (5,"Flag", self.user?._country, "Select your nationality")
        default:
            return (0,"none",nil,nil)
        }
    }
    
    func getGenderCellInfo(gender:String?) -> ProfileCellInfo{
        
        var iconName:String = "Unknown"
        
        if let g = gender {
            switch g {
            case "Male":
                iconName = "Male"
            case "Female":
                iconName = "Female"
            default:
                iconName = "Unknown"
            }
        }
        
        return (2,iconName,self.user?._gender, "Select your Gender")
    }
    
    func saveUserInfo(_ user:User, completion:@escaping (Bool,String)->()){

        AmazonDynamoDBManager.shared.SaveItem(user) { (error:Error?) in
            
            if let _ = error{
                completion(false, error!.infoMessage!)
            }else{
                completion(true,"Profile info have been saved successfully")
            }
        }
    }
}
