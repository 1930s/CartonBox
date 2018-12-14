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

typealias PHAssetMedia = (localIdentifier:String, type:PHAssetMediaType, size:Double?)  //size in MB
class MediaFilesViewModel{
    
    lazy var photos:[PHAsset] = []
    lazy var videos:[PHAsset] = []
    lazy var selectedPHAsset:[PHAssetMedia] = []
    var selectedVideos:[PHAsset]?{
        get{
            var selectedIdentifiers:[String] = []
            let _ = selectedPHAsset.filter { (element) -> Bool in
                if element.type == PHAssetMediaType.video{
                    selectedIdentifiers.append(element.localIdentifier)
                }
                
                return element.type == PHAssetMediaType.video
            }
            
            if selectedIdentifiers.count > 0, let asset = PHCacheManager.shared.fetchAssets(localIdentifiers: selectedIdentifiers, options: nil){
                    return asset
            }
            
            return nil
        }
    }
    var selectedImages:[PHAsset]?{
        get{
            var selectedIdentifiers:[String] = []
            let _ = selectedPHAsset.filter { (element) -> Bool in
                if element.type == PHAssetMediaType.image{
                    selectedIdentifiers.append(element.localIdentifier)
                }
                
                return element.type == PHAssetMediaType.image
            }
            
            if selectedIdentifiers.count > 0, let asset = PHCacheManager.shared.fetchAssets(localIdentifiers: selectedIdentifiers, options: nil){
                return asset
            }
            
            return nil
        }
    }
    
    let maxFileSize: Double = 25 //MB
    
    init() {
        
    }
    
    func filterPHAsset(type:PHAssetMediaType) -> [PHAssetMedia]{
        if selectedPHAsset.count <= 0 {
            return []
        }
        
        let filterItems = selectedPHAsset.filter { (element) -> Bool in
            return element.type == type
        }
        
        return filterItems
    }
    
    func appendPhotoAsset(_ newAsset:PHAsset) -> Bool{
        if validateAssetFileSize(newAsset) {
            self.selectedPHAsset.append((newAsset.localIdentifier, .image, getAssetFileSize(newAsset)))
            return true
        }
        
        return false
    }
    
    func appendVideoAsset(_ newAsset:PHAsset) -> Bool {
        if validateAssetFileSize(newAsset) {
            self.selectedPHAsset.append((newAsset.localIdentifier, .video, getAssetFileSize(newAsset)))
            return true
        }
        
        return false
    }

    func getAssetFileSize(_ asset:PHAsset)->Double?{
        let resources = PHAssetResource.assetResources(for: asset)
        var assetSize: Int64? = 0
        
        if let resource = resources.first {
            let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
            assetSize = Int64(bitPattern: UInt64(unsignedInt64!))
        }
        
        guard let _ = assetSize else {
            return nil
        }
        
        return Double(assetSize!)/Double(FileSizeFormat.megaByte.rawValue)
    }
    
    func indexAsset(of asset:PHAsset)->Int?{
        return self.selectedPHAsset.index(where: { (element) -> Bool in
            return element.localIdentifier == asset.localIdentifier
        })
    }
    
    func validateAssetFileSize(_ asset:PHAsset)->Bool{
        if let size = getAssetFileSize(asset) {
            return size <= maxFileSize
        }
        
        return false
    }
    
    func loadPhotos(completion:@escaping ()->Void){
        let _options = PHFetchOptions()
        _options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        _options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        
        DispatchQueue.global(qos: .background).async {
            self.photos.removeAll()
            self.photos = PHCacheManager.shared.fetchAssetCollection(with: PHAssetCollectionType.smartAlbum, subType: PHAssetCollectionSubtype.smartAlbumUserLibrary, options: _options)!
            completion()
        }
    }
    
    func loadVideos(completion:@escaping ()->Void){
        let _options = PHFetchOptions()
        _options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        _options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
        
        DispatchQueue.global(qos: .background).async {
            self.videos.removeAll()
            
            if let videos = PHCacheManager.shared.fetchAssetCollection(with: PHAssetCollectionType.smartAlbum, subType: PHAssetCollectionSubtype.smartAlbumVideos, options: _options){
                
                for v in videos{
                    if v.sourceType == PHAssetSourceType.typeUserLibrary{
                        self.videos.append(v)
                    }
                }
            }
            
            completion()
        }
    }
    
    func populateSelectedMedia(_ media:[PHAssetMedia]){
        self.selectedPHAsset.removeAll()
        
        for var item in media{
            self.selectedPHAsset.append((item.localIdentifier, item.type, item.size))
        }
    }
}
