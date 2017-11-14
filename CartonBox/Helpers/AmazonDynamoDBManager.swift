//
//  AWSDynamoDBHelper.swift
//  CartonBox
//
//  Created by kay weng on 04/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation
import AWSDynamoDB
import AWSAuthCore

typealias AmazonDynamoDBPaginatedOutput = (AWSDynamoDBPaginatedOutput?)->Void

protocol PAmazonDynamoDBManager{
    
    var mapper:AWSDynamoDBObjectMapper {get set}
    
    func GetItem(_ model:AnyClass, hasKey:String, rangeKey:String?, completionHandler: @escaping (AnyObject?)->())
    func SaveItem(_ model: AWSDynamoDBModeling & AWSDynamoDBObjectModel, completionHandler:AmazonClientCompletition?)
    func DeleteItem(_ model: AWSDynamoDBModeling & AWSDynamoDBObjectModel, completionHandler:AmazonClientCompletition?)
    func Scan(_ model:AnyClass, expression:AWSDynamoDBScanExpression, completionHandler: AmazonDynamoDBPaginatedOutput?)
    func Query(_ model:AnyClass, expression:AWSDynamoDBQueryExpression, completionHandler:@escaping (AWSDynamoDBPaginatedOutput?)->())
}

class AmazonDynamoDBManager : PAmazonDynamoDBManager{
    
    var mapper: AWSDynamoDBObjectMapper
    
    class var shared: AmazonDynamoDBManager {
        
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
    
    func GetItem(_ model: AnyClass, hasKey: String, rangeKey: String?, completionHandler: @escaping (AnyObject?) -> ()) {

        mapper.load(model, hashKey: hasKey, rangeKey: rangeKey).continueWith { (task:AWSTask<AnyObject>!)  -> Any? in

            if let _ = task.error as NSError? {
                //Todo:Log an error
                completionHandler(nil)
            }else{
                completionHandler(task?.result)
            }
            
            return nil
        }
    }

    func SaveItem(_ model: AWSDynamoDBModeling & AWSDynamoDBObjectModel, completionHandler:AmazonClientCompletition?) {

        mapper.save(model).continueWith { (task:AWSTask<AnyObject>!) -> Any? in
            DispatchQueue.main.async(execute: {
                if let error = task.error as NSError? {
                    //Todo:Log an error
                    completionHandler?(error)
                }else{
                    completionHandler?(nil)
                }
            })
        }
    }

    func DeleteItem(_ model: AWSDynamoDBModeling & AWSDynamoDBObjectModel, completionHandler:AmazonClientCompletition?) {
        
        mapper.remove(model, completionHandler: { (error:Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler?(error)
            })
        })
    }
    
    func Scan(_ model: AnyClass, expression: AWSDynamoDBScanExpression, completionHandler: AmazonDynamoDBPaginatedOutput?) {
        
        mapper.scan(model, expression: expression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>) -> Any? in
            DispatchQueue.main.async(execute: {
                if let _ = task.error as NSError? {
                    //Todo:Log an error
                    completionHandler?(nil)
                }else if let paginatedOutput = task.result{
                    completionHandler?(paginatedOutput)
                }
            })
        })
    }
    
    func Query(_ model:AnyClass, expression:AWSDynamoDBQueryExpression, completionHandler:@escaping (AWSDynamoDBPaginatedOutput?)->()){
        
        mapper.query(model, expression: expression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>) -> Any? in
            
            DispatchQueue.main.async(execute: {
                if let _ = task.error as NSError? {
                    //Todo:Log an error
                    completionHandler(nil)
                }else if let paginatedOutput = task.result{
                    completionHandler(paginatedOutput)
                }
            })
        })
    }
}
