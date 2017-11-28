//
//  BoxDetailViewModel.swift
//  CartonBox
//
//  Created by kay weng on 17/11/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation
import AWSDynamoDB

class BoxDetailViewModel{
 
    private var id: String?
    
    var title:String!
    var description:String!
    var receipents:[String]!
    var files: [String]!
    
    init() {
        
        self.title = ""
        self.description = ""
        self.receipents = []
        self.files = []
    }
    
    func loadBoxDetail(id:String, completion: AmazonClientCompletition?){
        
        self.id = id
        
        guard let _ = self.id else {
            return
        }
        
        completion?(nil)
    }
    
    func saveBoxDetail(){
        
    }
}
