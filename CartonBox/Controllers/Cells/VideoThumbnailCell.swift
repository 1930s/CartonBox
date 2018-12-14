//
//  VideoThumbnailCell.swift
//  CartonBox
//
//  Created by kay weng on 11/01/2018.
//  Copyright © 2018 kay weng. All rights reserved.
//

import UIKit
import Photos
import AVKit

let videoThumbnailCell = "VideoThumbnailCell"

protocol VideoThumbnailCellProtocol {
    func onSelectedAsset(_ asset:PHAsset, promptErrorIfAny:Bool, success:SuccessBlock?, failure:FailureBlock?)
    func onUnSelectedAsset(_ asset:PHAsset)
    func onViewSelectedAsset(_ asset:PHAsset)
}

class VideoThumbnailCell: UICollectionViewCell {

    @IBOutlet weak var imgVideo: UIImageView!
    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var lblDuration: UILabel!
    
    var selectVideoGesture:UITapGestureRecognizer!
    var viewTapGesture:UITapGestureRecognizer!
    var asset:PHAsset!
    var selectedPHAsset:Bool!{
        didSet{
            UIView.transition(with: self.imgSelected, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.imgSelected.isHidden = !self.selectedPHAsset
            }, completion: nil)
        }
    }
    var delegate:VideoThumbnailCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgVideo.corner(rounding: UIRectCorner.allCorners, size: CGSize(width: 0, height: 0))
    
        self.selectVideoGesture = UITapGestureRecognizer(target: self, action: #selector(VideoThumbnailCell.onSelectedVideo))
        self.viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(VideoThumbnailCell.viewSelectVideo))
        
        selectVideoGesture.delegate = self
        selectVideoGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(selectVideoGesture)
        
        viewTapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(viewTapGesture)
        
        selectVideoGesture.require(toFail: viewTapGesture)
        
        selectVideoGesture.delaysTouchesBegan = true
        viewTapGesture.delaysTouchesBegan = true
        
    }
    
    //MARK: - Actions
    @objc func onSelectedVideo(sender: UITapGestureRecognizer){
        if !selectedPHAsset{
            self.delegate?.onSelectedAsset(self.asset, promptErrorIfAny: true, success: { (done) in
                self.selectedPHAsset = !self.selectedPHAsset
            }, failure: { (error) in
                self.selectedPHAsset = false
            })
        }else{
            self.delegate?.onUnSelectedAsset(self.asset)
        }
    }
    
    @objc func viewSelectVideo(sender: UITapGestureRecognizer){
        self.delegate?.onViewSelectedAsset(self.asset)
    }
}

extension VideoThumbnailCell: UIGestureRecognizerDelegate {
 
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.viewTapGesture && otherGestureRecognizer == self.selectVideoGesture {
            return true
        }

        return false
    }
}
