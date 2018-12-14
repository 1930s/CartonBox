//
//  PhotoLibraryViewModel.swift
//  CartonBox
//
//  Created by kay weng on 31/12/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation
import UIKit
import Photos
import SnackKit

class MediaFilesViewModel{
    
    var photos:[PHAsset]!
    var videos:[PHAsset]!
    var selectedVideos:[PHAsset]!
    var selectedPhotos:[PHAsset]!
    
    init() {
        self.photos = []
        self.videos = []
        self.selectedVideos = []
        self.selectedPhotos = []
        
        let _options = PHFetchOptions()
        
        _options.includeAssetSourceTypes = .typeUserLibrary
        _options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        s
        
    }
}
