//
//  PhotoThumbnailCell.swift
//  CartonBox
//
//  Created by kay weng on 31/12/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit
import Photos
import SnackKit

let photoThumbnailCell = "PhotoThumbnailCell"

protocol PhotoThumbnailCellProtocol {
    func onSelectedAsset(_ asset:PHAsset, promptErrorIfAny:Bool, success:SuccessBlock?, failure:FailureBlock?)
    func onUnSelectedAsset(_ asset:PHAsset)
    func onViewSelectedAsset(_ asset:PHAsset)
}

class PhotoThumbnailCell: UICollectionViewCell {

    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var imgSelected: UIImageView!
    
    var asset:PHAsset!
    var selectedPHAsset:Bool!{
        didSet{
            UIView.transition(with: self.imgSelected, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.imgSelected.isHidden = !self.selectedPHAsset
            }, completion: nil)
        }
    }
    var delegate:PhotoThumbnailCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestures()
        
        self.imgPhoto.corner(rounding: UIRectCorner.allCorners, size: CGSize(width: 0, height: 0))
    }

    //MARK: - Actions
    @objc func onSelectedImage(){
        
        if !selectedPHAsset{
            self.delegate?.onSelectedAsset(asset, promptErrorIfAny: true, success: { (done) in
                self.selectedPHAsset = !self.selectedPHAsset
            }, failure: { (error) in
                self.selectedPHAsset = false
            })
        }else{
            self.delegate?.onUnSelectedAsset(self.asset)
        }
    }
    
    @objc func viewSelectImage(){
        self.selectedPHAsset = selectedPHAsset ? selectedPHAsset : false
        self.delegate?.onViewSelectedAsset(self.asset)
    }

    //MARK: - Methods
    fileprivate func addGestures() {
        let selectImageGesture = UITapGestureRecognizer(target: self, action: #selector(PhotoThumbnailCell.onSelectedImage))
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(PhotoThumbnailCell.viewSelectImage))
        
        viewTapGesture.require(toFail: selectImageGesture)
        viewTapGesture.delaysTouchesBegan = true
        viewTapGesture.numberOfTapsRequired = 1
        
        selectImageGesture.delaysTouchesBegan = true
        selectImageGesture.numberOfTapsRequired = 2
        
        self.addGestureRecognizer(selectImageGesture)
        self.addGestureRecognizer(viewTapGesture)
    }
}
