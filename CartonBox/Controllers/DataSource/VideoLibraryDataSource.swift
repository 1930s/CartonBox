//
//  VideoLibraryDataSource.swift
//  CartonBox
//
//  Created by kay weng on 10/01/2018.
//  Copyright © 2018 kay weng. All rights reserved.
//

import Foundation
import UIKit
import SnackKit
import Photos

class VideoLibraryDataSource: NSObject, UICollectionViewProtocol, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{

    @IBOutlet weak var controller:VideoLibraryController!
    
    var videos:[PHAsset]!{
        didSet{
            DispatchQueue.main.async {
                self.controller.collectionView?.reloadData()
            }
        }
    }
    var delegate: UICollectionView?{
        didSet{
            self.initWithDataSource()
        }
    }
    
    internal func initWithDataSource() {
        self.controller.collectionView?.reloadData()
    }
    
    //MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard videos != nil else{
            return 0
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoThumbnailCell, for: indexPath) as! VideoThumbnailCell
        
        if let asset = videos?[row]{
            let cellSize = CGSize(width: cell.frame.width, height: cell.frame.height)
            let options = PHImageRequestOptions()
            
            options.isSynchronous = true
            options.isNetworkAccessAllowed = true
            options.resizeMode = PHImageRequestOptionsResizeMode.none
            options.deliveryMode = .opportunistic
            
            cell.delegate = self.controller
            cell.asset = asset
            cell.selectedPHAsset = false
            
            if let _ = controller.vm.indexAsset(of: asset){
                cell.selectedPHAsset = true
            }else{
                cell.selectedPHAsset = false
            }
            
            PHCacheManager.shared.fetchAssetImage(asset: asset, targetSize: cellSize, mode: .aspectFill, options: options, completion: { (image) in
                cell.imgVideo.image = image
            })
            
            cell.lblDuration.text = "\(stringFromTimeInterval(interval: asset.duration))"
        }
        
        return cell
    }
    
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.controller.collectionView!.frame.width/4
        
        return CGSize(width: width ,height: width)
    }
    
    fileprivate func stringFromTimeInterval(interval: TimeInterval) -> NSString {
        let ti = NSInteger(interval)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return NSString(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
}
