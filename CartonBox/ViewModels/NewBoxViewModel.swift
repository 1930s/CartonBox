//
//  NewBoxViewModel.swift
//  CartonBox
//
//  Created by kay weng on 01/12/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation

class NewBoxViewModel{
    
    var title:String!
    var description:String!
    var receipents:[String]!
    var photos:[String]!
    var videos:[String]!
    
    init() {
        self.title = ""
        self.description = ""
        self.receipents = []
        self.photos = []
        self.videos = []
    }
    
    public func validated()->Bool{
        return !self.title.isEmpty && self.receipents.count > 0
    }
    
    
    
}
