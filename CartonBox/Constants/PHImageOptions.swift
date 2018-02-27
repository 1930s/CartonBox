//
//  PHImageOptions.swift
//  CartonBox
//
//  Created by kay weng on 21/01/2018.
//  Copyright © 2018 kay weng. All rights reserved.
//

import Foundation
import Photos

public struct PHAssetRequestOptions{

    static func GetPHImageRequestOptions(mode:PHImageRequestOptionsDeliveryMode,isSynchronous sync:Bool, resizeMode resize:PHImageRequestOptionsResizeMode, allowNetworkAccess access:Bool)->PHImageRequestOptions{
        
        let options = PHImageRequestOptions()
        
        options.isSynchronous = sync
        options.isNetworkAccessAllowed = access
        options.resizeMode = resize
        options.deliveryMode = mode
        
        return options
    }
    
    static func GetPHVideoRequestOptions(mode:PHVideoRequestOptionsDeliveryMode, allowNetworkAccess access:Bool)->PHVideoRequestOptions{
        
        let options = PHVideoRequestOptions()
        
        options.isNetworkAccessAllowed = access
        options.deliveryMode = mode
        
        return options
    }
}

