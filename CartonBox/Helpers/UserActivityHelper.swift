//
//  UserActivityHelper.swift
//  CartonBox
//
//  Created by kay weng on 04/11/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation
import SnackKit

class UserActivityHelper{
    
    static func CreateFacebookLoginActivity(success: @escaping SuccessBlock, failure: @escaping FailureBlock){
     
        let activity = CartonBoxUserActivity()
        
        activity?._activityId = UUID().uuidString
        activity?._userId = appDelegate.cartonboxUser?._userId
        activity?._type = UserAcitvityEnum.FacebookLogin.rawValue
        activity?._message = UserActivityMessageEnum.Login.rawValue
        activity?._action = "NA"
        activity?._linkUrl = "NA"
        activity?._status = UserActivityStatusEnum.New.rawValue as NSNumber
        activity?._createdOn = Date().now.toLocalString(DateFormat.dateTime)
        
        self.SaveUserActivity(activity!) { (error) in
            
            if let _ = error {
                failure(error!)
            }else{
                success(activity)
            }
        }
    }
    
    static func CreateFacebookLogoutActivity(success: @escaping SuccessBlock,failure: @escaping FailureBlock){
        
        let activity = CartonBoxUserActivity()
        
        activity?._activityId = UUID().uuidString
        activity?._userId = appDelegate.cartonboxUser?._userId
        activity?._type = UserAcitvityEnum.FacebookLogout.rawValue
        activity?._message = UserActivityMessageEnum.Logout.rawValue
        activity?._action = "NA"
        activity?._linkUrl = "NA"
        activity?._status = UserActivityStatusEnum.New.rawValue as NSNumber
        activity?._createdOn = Date().now.toLocalString(DateFormat.dateTime)
        
        self.SaveUserActivity(activity!) { (error) in
            
            if let _ = error {
                failure(error!)
            }else{
                success(activity)
            }
        }
    }
    
    private static func SaveUserActivity(_ activity:CartonBoxUserActivity, completion:@escaping (Error?)->()){
        
        AmazonDynamoDBManager.shared.SaveItem(activity) { (error) in
            
            if let err = error{
                completion(err)
            }else{
                completion(nil)
            }
        }
    }
}
