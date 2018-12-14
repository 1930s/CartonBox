//
//  DocumentLibraryController.swift
//  CartonBox
//
//  Created by kay weng on 19/12/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Photos
import AVKit
import AVFoundation
import SnackKit

class VideoLibraryController: UICollectionViewController {

    @IBOutlet var dtVideoLibrary: VideoLibraryDataSource!
    
    var itemInfo = IndicatorInfo(title: "Videos")
    var vm:MediaFilesViewModel!
    var pages:[VideoViewerController] = []
    var pageViewer:PHPageViewController = sb.instantiateViewController(withIdentifier: ControllerName.PHPageViewVC) as! PHPageViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.dataSource = self.dtVideoLibrary
        self.collectionView?.delegate = self.dtVideoLibrary
        
        self.pageViewer.videoLibrary = self
        
        self.collectionView!.register(UINib(nibName: videoThumbnailCell, bundle:nil), forCellWithReuseIdentifier: videoThumbnailCell)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3) {
            if self.dtVideoLibrary.videos == nil {
                appDelegate.showLoading { (hideLoading) in
                    self.vm.loadVideos {
                        
                        hideLoading()
                        
                        self.dtVideoLibrary.videos = self.vm.videos
                        
                        for i in 0...self.vm.videos.count-1 {
                            let vv = sb.instantiateViewController(withIdentifier: ControllerName.VideoViewerVC) as! VideoViewerController
                            vv.pvController = self.pageViewer
                            vv.asset = self.vm.videos[i]
                            vv.tag = i
                            
                            self.pages.append(vv)
                        }
                        
                        self.pageViewer.pages = self.pages
                        
                        DispatchQueue.main.async {
                            self.itemInfo.title = "Videos (\(self.vm.videos.count))"
                            
                            if let pagerTabStrip = self.parent as? ButtonBarPagerTabStripViewController {
                                pagerTabStrip.buttonBarView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Methods
    func updateThumbnailCell(_ index:Int,selected:Bool){
        self.collectionView?.reloadItems(at: [NSIndexPath(row: index, section: 0) as IndexPath])
    }
}

//MARK: - IndicatorInfoProvider
extension VideoLibraryController : IndicatorInfoProvider{
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

//MARK: - Extension
extension VideoLibraryController : VideoThumbnailCellProtocol{
    func onSelectedAsset(_ asset: PHAsset, promptErrorIfAny: Bool, success successCallBack: SuccessBlock?, failure failureCallBack: FailureBlock?) {
        
        if self.vm.appendVideoAsset(asset) {
            self.itemInfo.title = "Video (\(self.vm.selectedVideos?.count ?? 0))"
            
            if let index = self.vm.videos.index(of: asset){
                self.updateThumbnailCell(index, selected: true)
                successCallBack?(true)
            }
        }else{
            if promptErrorIfAny{
                alert(title: Message.Error, message: Message.ExceedMaxFileSize)
            }else{
                let error = NSError(domain: "", code: ApplicationError.ExceedMaxFileSize.rawValue, userInfo: nil)
                failureCallBack?(error)
            }
            
            if let index = self.vm.photos.index(of: asset){
                self.updateThumbnailCell(index, selected: false)
            }
        }
    }
    
    func onUnSelectedAsset(_ asset: PHAsset) {
        if let r = self.vm.indexAsset(of: asset){
            self.vm.selectedPHAsset.remove(at: r)
            self.itemInfo.title = "Videos (\(self.vm.selectedVideos?.count ?? 0))"
        }
        
        if let index = self.vm.videos.index(of: asset){
            self.updateThumbnailCell(index, selected: true)
        }
    }
    
    func onViewSelectedAsset(_ asset: PHAsset) {
        if let index = vm.videos.index(of: asset){
            pageViewer.selectedAssetIndex = index
        }
        
        if !pageViewer.isBeingPresented{
            self.present(pageViewer, animated: true, completion: nil)
        }
    }
}
