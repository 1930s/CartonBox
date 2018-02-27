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
    func onSelectedAsset(_ asset:PHAsset)
    func onUnSelectedAsset(_ asset:PHAsset)
    func onViewSelectedAsset(_ asset:PHAsset)
}

class VideoThumbnailCell: UICollectionViewCell {

    @IBOutlet weak var imgVideo: UIImageView!
    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var lblDuration: UILabel!
    
    var asset:PHAsset!
    var selectedPHAsset:Bool!{
        didSet{
            self.imgSelected.isHidden = !selectedPHAsset
        }
    }
    var delegate:VideoThumbnailCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestures()
        
        self.imgVideo.corner(rounding: UIRectCorner.allCorners, size: CGSize(width: 0, height: 0))
    }
    
    //MARK: - Actions
    @objc func onSelectedVideo(){
        
        self.selectedPHAsset = !selectedPHAsset
        
        if selectedPHAsset{
            self.delegate?.onSelectedAsset(self.asset)
        }else{
            self.delegate?.onUnSelectedAsset(self.asset)
        }
    }
    
    @objc func viewSelectVideo(){
        
        self.selectedPHAsset = selectedPHAsset ? selectedPHAsset : false
        self.delegate?.onViewSelectedAsset(self.asset)
    }

    //MARK: - Methods
    fileprivate func addGestures() {
        let selectVideoGesture = UITapGestureRecognizer(target: self, action: #selector(VideoThumbnailCell.onSelectedVideo))
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(VideoThumbnailCell.viewSelectVideo))
        
        viewTapGesture.delaysTouchesBegan = true
        viewTapGesture.numberOfTapsRequired = 1
        
        selectVideoGesture.delaysTouchesBegan = true
        selectVideoGesture.numberOfTapsRequired = 2
        
        self.addGestureRecognizer(selectVideoGesture)
        self.addGestureRecognizer(viewTapGesture)
    }
}
