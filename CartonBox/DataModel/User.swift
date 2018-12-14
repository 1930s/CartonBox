//
//  User.swift
//  CartonBox
//
//  Created by kay weng on 19/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation
import AWSDynamoDB

final class CartonBoxUser: AWSDynamoDBObjectModel, AWSDynamoDBModeling{
    
    static func dynamoDBTableName() -> String {
        return "CartonBoxUser"
    }
    
    static func hashKeyAttribute() -> String {
        return "UserId"
    }
    
    var UserId:String?
    var Name:String?
//    var Gender:String?
//    var DOB:String?
//    var Email:String?
//    var Country:String?
//    var Active:NSNumber?
//    var ActiveTimeStamp:String?
    
}
