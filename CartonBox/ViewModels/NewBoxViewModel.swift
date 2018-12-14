//
//  NewBoxViewModel.swift
//  CartonBox
//
//  Created by kay weng on 01/12/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation
import SnackKit

class NewBoxViewModel{
    
    var title:String!
    var description:String!
    var passcode:String?
    
    lazy var receipents:[String] = []
    lazy var media:[PHAssetMedia] = []
    var storageSize:Double! //MB
    
    init() {
        self.title = ""
        self.description = ""
        self.storageSize = 50
    }
    
    public func validated()->Bool{
        return !self.title.isEmpty && self.receipents.count > 0 && self.media.count > 0
    }
    
    public func getMediaFileSize()->String{
        var size:Double = 0.0
        
        if self.media.count > 0 {
            for var item in media {
                if let itemSize = item.size{
                    size += itemSize
                }
            }
        }
        
        return "\(size.rounded(toPlaces: 2)) / \(storageSize!) MB"
    }
    
    public func clear(){
        self.title = ""
        self.description = ""
        self.receipents.removeAll()
        self.media.removeAll()
    }
}
