//
//  PhotoLibraryDataSource.swift
//  CartonBox
//
//  Created by kay weng on 31/12/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation
import UIKit
import SnackKit
import Photos

class PhotoLibraryDataSource: NSObject, UICollectionViewProtocol, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    @IBOutlet weak var controller:PhotoLibraryController!

    var photos:[PHAsset]!{
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
        guard photos != nil else{
            return 0
        }
        
        return photos.count > 0 ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoThumbnailCell, for: indexPath) as! PhotoThumbnailCell
        let asset = photos[row]
        let options = PHAssetRequestOptions.GetPHImageRequestOptions(mode: .fastFormat, isSynchronous: true, resizeMode: .none, allowNetworkAccess: true)
        
        if let _ = controller.vm.indexAsset(of: asset){
            cell.selectedPHAsset = true
        }else{
            cell.selectedPHAsset = false
        }
        
        cell.delegate = controller
        cell.asset = asset
        
        PHCacheManager.shared.fetchAssetImage(asset: asset, targetSize: controller.cellSize, mode: .aspectFill, options: options, completion: { (image) in
            cell.imgPhoto.image = image
        })
        
        return cell
    }
    
    //MARK: - UICollectionViewDelegate    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return controller.cellSize
    }
}
