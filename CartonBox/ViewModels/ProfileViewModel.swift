//
//  ProfileViewModel.swift
//  CartonBox
//
//  Created by kay weng on 12/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation

class ProfileViewModel{
    
    var userId:String?
    var name:String?
    
    init() {
        
    }
    
    func GetUserDetail(_ userId:String){
        
        if let user = AmazonDynamoDBManager.sharedInstance.GetItem(CartonBoxUser.self, hasKey: userId, rangeKey: nil) as? CartonBoxUser {
            
            self.userId = user.UserId
            self.name = user.Name
        }
    }
    
    func SaveUserDetail(_ user:CartonBoxUser, completion:@escaping (Bool,String)->()){

        AmazonDynamoDBManager.sharedInstance.SaveItem(user) { (error:Error?) in
            
            if let _ = error{
                completion(false, error!.infoMessage!)
            }else{
                completion(true,"Saved Successful")
            }
        }
    }
}
