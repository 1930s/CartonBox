//
//  ActivityViewModel.swift
//  CartonBox
//
//  Created by kay weng on 05/11/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation
import AWSDynamoDB

class ActivityViewModel{
 
    var allActivities:[UserActivity]!
    var activityList: Dictionary<String,[UserActivity]>!
    
    init() {
        
        self.allActivities = [UserActivity]()
        self.activityList = Dictionary<String,[UserActivity]>()
    }
    
    func loadUserActivities(numberOfRecord: Int, completion: AmazonClientCompletition?){
        
        guard let _ = appDelegate.cartonboxUser else {
            return
        }
        
        self.allActivities.removeAll()
        self.activityList.removeAll()
        
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "userId= :userId"
        queryExpression.expressionAttributeValues = [":userId": appDelegate.cartonboxUser!._userId!]
        queryExpression.limit = NSNumber(value: numberOfRecord)
        queryExpression.scanIndexForward = false
        
        AmazonDynamoDBManager.shared.Query(UserActivity.self, expression: queryExpression) { (paginatedOuput) in
            
            if let po = paginatedOuput{
            
                let items = po.items as! [UserActivity]
        
                for activity in items{
                    self.allActivities.append(activity)
                }
            }
            
            if self.allActivities.count > 0{
                
                self.allActivities.sort(by: { ( a1, a2) -> Bool in
                    return DateFormat.GetDate(from: a1._createdOn!)! > DateFormat.GetDate(from: a2._createdOn!)!
                })
                
                self.groupingActivityData()
            }
            
            completion!(nil)
        }
    }
    
    private func groupingActivityData(){
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yyyy hh:mm:ss a"
        dateformatter.timeZone = NSTimeZone.local

        //Today
        let todayActivity = allActivities.filter { (data) -> Bool in
            
            if let dt = dateformatter.date(from: data._createdOn!){
                return Calendar.current.isDateInToday(dt)
            }
            
            return false
        }
        
        if todayActivity.count > 0{
            self.activityList["Today"] = todayActivity
        }else{
            self.activityList["Today"] = [UserActivity]()
        }
        
        //Yesterday
        let yesterdayActivity = allActivities.filter { (data) -> Bool in
            
            if let dt = dateformatter.date(from: data._createdOn!){
                return Calendar.current.isDateInYesterday(dt)
            }
            
            return false
        }
        
        if yesterdayActivity.count > 0{
            self.activityList["Yesterday"] = yesterdayActivity
        }

        //Past
        let pastActivity = allActivities.filter { (data) -> Bool in

            if let dt = dateformatter.date(from: data._createdOn!){
                return !Calendar.current.isDateInToday(dt) && !Calendar.current.isDateInYesterday(dt)
            }
            
            return false
        }
        
        if pastActivity.count > 0{
            self.activityList["Past"] = pastActivity
        }
    }
}
