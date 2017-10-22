//
//  AWSDynamoDBHelper.swift
//  CartonBox
//
//  Created by kay weng on 04/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation
import AWSDynamoDB

typealias AmazonDynamoDBPaginatedOutput = (AWSDynamoDBPaginatedOutput?)->()

protocol PAmazonDynamoDBManager{
    
    var mapper:AWSDynamoDBObjectMapper {get set}
    
    func GetItem(_ model:AnyClass, hasKey:String, rangeKey:String?) throws ->AnyObject?
    func SaveItem(_ model: AWSDynamoDBModeling & AWSDynamoDBObjectModel, completion:AmazonClientCompletition?)
    func DeleteItem(_ model: AWSDynamoDBModeling & AWSDynamoDBObjectModel, completion:AmazonClientCompletition?)
    func Scan(_ model:AnyClass, expression:AWSDynamoDBScanExpression, completion: AmazonDynamoDBPaginatedOutput?)
    func Query(_ model:AnyClass, expression:AWSDynamoDBQueryExpression, completion: AmazonDynamoDBPaginatedOutput?)
}

class AmazonDynamoDBManager : PAmazonDynamoDBManager{
    
    var mapper: AWSDynamoDBObjectMapper
    
    class var sharedInstance: AmazonDynamoDBManager {
        
        struct Static {
            static var instance: AmazonDynamoDBManager? = nil
        }
        
        if Static.instance == nil{
            Static.instance = AmazonDynamoDBManager()
        }
        
        return Static.instance!
    }
    
    init() {
        mapper = AWSDynamoDBObjectMapper.default()
    }
    
    func GetItem(_ model: AnyClass, hasKey: String, rangeKey: String?) ->AnyObject?{

        mapper.load(model, hashKey: hasKey, rangeKey: rangeKey).continueWith { (task:AWSTask<AnyObject>!)  -> Any? in
            
            if let _ = task.error as NSError? {
                //Todo:Log an error
                return nil
            }
            
            return task.result
        }
        
        return nil
    }
    
    func SaveItem(_ model: AWSDynamoDBModeling & AWSDynamoDBObjectModel, completion:AmazonClientCompletition?) {
        
        mapper.save(model).continueWith { (task:AWSTask<AnyObject>!) -> Any? in
            
            if let error = task.error as NSError? {
                //Todo:Log an error
                completion?(error)
                return nil
            }
            
            completion?(nil)
            return nil
        }
    }

    func DeleteItem(_ model: AWSDynamoDBModeling & AWSDynamoDBObjectModel, completion:AmazonClientCompletition?) {
        
        mapper.remove(model, completionHandler: { (error:Error?) in
            completion?(error)
        })
    }
    
    func Scan(_ model: AnyClass, expression: AWSDynamoDBScanExpression, completion: AmazonDynamoDBPaginatedOutput?) {
        
        mapper.scan(model, expression: expression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>) -> Any? in
            
            if let _ = task.error as NSError? {
                //Todo:Log an error
                completion?(nil)
            }else if let paginatedOutput = task.result{
                completion?(paginatedOutput)
            }
            
            return nil
        })
    }
    
    func Query(_ model:AnyClass, expression:AWSDynamoDBQueryExpression, completion: AmazonDynamoDBPaginatedOutput?){
        
        mapper.query(model, expression: expression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>) -> Any? in
            
            if let _ = task.error as NSError? {
                //Todo:Log an error
                completion?(nil)
            }else if let paginatedOutput = task.result{
                completion?(paginatedOutput)
            }
            
            return nil
        })
    }
}
