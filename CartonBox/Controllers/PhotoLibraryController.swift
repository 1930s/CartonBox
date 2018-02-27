//
//  PhotoLibraryController.swift
//  CartonBox
//
//  Created by kay weng on 19/12/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Photos
import SnackKit

private let reuseIdentifier = "PhotoThumbnailCell"

class PhotoLibraryController: UICollectionViewController {

    @IBOutlet var dtPhotoLibrary: PhotoLibraryDataSource!
    
    var itemInfo = IndicatorInfo(title: "Photos")
    var vm:MediaFilesViewModel!
    var pages:[PhotoViewerController] = []
    var pageViewer:PHPageViewController =  sb.instantiateViewController(withIdentifier: ControllerName.PHPageViewVC) as! PHPageViewController
    var cellSize:CGSize!
    var imageSize:CGSize!
    var pagerTab:PHAssetsController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pageViewer.photoLibrary = self
        
        self.collectionView?.dataSource = self.dtPhotoLibrary
        self.collectionView?.delegate = self.dtPhotoLibrary
        self.collectionView!.register(UINib(nibName: photoThumbnailCell, bundle:nil), forCellWithReuseIdentifier: photoThumbnailCell)
        
        initializeCollectionLayout()
        initPhotoLibrary()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods
    fileprivate func initializeCollectionLayout() {
        let itemSize = (UIScreen.main.bounds.width/4)
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1.5, bottom: 0, right: -1.5)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        self.cellSize = CGSize(width: itemSize, height: itemSize)
        self.imageSize = CGSize(width: ScreenSize.SCREEN_WIDTH-10, height: ScreenSize.SCREEN_HEIGHT * 0.75)
        
        self.collectionView!.collectionViewLayout = layout
    }
    
    fileprivate func initPhotoLibrary(){
    
        appDelegate.showLoading { (hideLoading) in
            
            PHCacheManager.shared.resetCachedAssets()
            
            self.vm.loadPhotos {
                
                DispatchQueue.global(qos: .background).async {
                    
                    PHCacheManager.shared.startCachingPHAssets(self.vm.photos, targetSize: self.cellSize, contentMode: PHImageContentMode.aspectFill, options: PHAssetRequestOptions.GetPHImageRequestOptions(mode: .fastFormat, isSynchronous: true, resizeMode: .none, allowNetworkAccess: true))
                }
                
                hideLoading()
                
                self.dtPhotoLibrary.photos = self.vm.photos
                
                for i in 0...self.vm.photos.count-1 {
                    let pv = sb.instantiateViewController(withIdentifier: ControllerName.PhotoViewerVC) as! PhotoViewerController
                    pv.pvController = self.pageViewer
                    pv.asset = self.vm.photos[i]
                    pv.imageSize = self.imageSize
                    pv.tag = i
                    
                    self.pages.append(pv)
                }
                
                self.pageViewer.pages = self.pages
                
                DispatchQueue.main.async {
                    self.itemInfo.title = "Photos (\(self.vm.photos.count))"
                    
                    if let pagerTabStrip = self.parent as? ButtonBarPagerTabStripViewController {
                        pagerTabStrip.buttonBarView.reloadData()
                    }
                }
            }
        }
    }

    func updateThumbnailCell(_ index:Int,selected:Bool){
        
        let indexPath = NSIndexPath(row: index, section: 0)
        
        self.collectionView?.reloadItems(at: [indexPath as IndexPath])
    }
}

//MARK: - IndicatorInfoProvider
extension PhotoLibraryController : IndicatorInfoProvider{
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

//MARK: - Extension
extension PhotoLibraryController : PhotoThumbnailCellProtocol{
    
    func onSelectedAsset(_ asset: PHAsset) {
        
        self.vm.selectedPhotos.append(asset)
        
        if let index = self.vm.photos?.index(of: asset){
            self.updateThumbnailCell(index, selected: true)
        }
    }
    
    func onUnSelectedAsset(_ asset: PHAsset) {
        
        if let r = self.vm.selectedPhotos.index(of: asset){
            self.vm.selectedPhotos.remove(at: r)
        }
        
        if let index = self.vm.photos?.index(of: asset){
            self.updateThumbnailCell(index, selected: true)
        }
    }
    
    func onViewSelectedAsset(_ asset: PHAsset) {
        
        if let index = vm.photos.index(of: asset){
            pageViewer.selectedAssetIndex = index
        }
        
        self.present(pageViewer, animated: true, completion: nil)
    }
}

