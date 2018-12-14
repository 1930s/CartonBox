//
//  ViewPhotoController.swift
//  CartonBox
//
//  Created by kay weng on 03/01/2018.
//  Copyright © 2018 kay weng. All rights reserved.
//

import UIKit
import Photos
import SnackKit
import CoreLocation

class PhotoViewerController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var srcViewImage: UIScrollView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var imgPopup: UIImageView!
    @IBOutlet weak var constPhotoHeight: NSLayoutConstraint!
    @IBOutlet weak var lblPhotoInfo: UILabel!
    @IBOutlet weak var lblLoading: UILabel!
    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!
    
    var pvController:UIViewController?
    var asset:PHAsset!
    var imageSize:CGSize!
    var imageOptions: PHImageRequestOptions = PHAssetRequestOptions.GetPHImageRequestOptions(mode: .highQualityFormat, isSynchronous: false, resizeMode: .none, allowNetworkAccess: true)
    var tag:Int!
    var staticImageHeight:CGFloat?
    var showLoading:Bool!{
        didSet{
            if showLoading{
                self.lblLoading.isHidden = false
                self.indicatorLoading.startAnimating()
            }else{
                self.lblLoading.isHidden = true
                self.indicatorLoading.stopAnimating()
            }
        }
    }
    lazy var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addGestures()
        
        self.showLoading = false
        self.srcViewImage.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        self.displayImage(animationOptions: [.transitionCrossDissolve])
        self.retrieveImageLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        self.srcViewImage.zoomScale = 1.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Actions
    @IBAction func onClose(_ sender: Any) {
        self.dismissPhotoViewer()
    }
    
    @IBAction func swipeBottom(_ sender:Any){
        self.dismissPhotoViewer()
    }
    
    @IBAction func doubleTap(_ sender: Any) {
        guard !self.showLoading else {
            return
        }
        
        if let page = self.pvController as? PHPageViewController{
            if let photoLibrary = page.photoLibrary{
                let vm = photoLibrary.vm
                
                if let _ = vm?.indexAsset(of: asset){
                    photoLibrary.onUnSelectedAsset(self.asset)
                    self.animateUnselectedPhoto()
                }else{
                    photoLibrary.onSelectedAsset(asset, promptErrorIfAny: false, success: { (done) in
                        self.animateSelectedPhoto()
                    }) { (error) in
                        if let _ = error{
                            let errMessage = ApplicationErrorHandler.retrieveApplicationErrorMessage(code: (error! as NSError).code)
                            self.alert(title: Message.Error, message: errMessage)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Methods
    fileprivate func addGestures() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(PhotoViewerController.doubleTap))
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(PhotoViewerController.swipeBottom))
        
        doubleTapGesture.numberOfTapsRequired = 2
        swipeDownGesture.direction = .down
        
        doubleTapGesture.delegate = self
        swipeDownGesture.delegate = self
        
        self.view.addGestureRecognizer(doubleTapGesture)
        self.view.addGestureRecognizer(swipeDownGesture)
    }
    
    
    fileprivate func retrieveImageLocation(){
        if let location = self.asset.location{
            LocationManager.shared.retrieveLocationAddress(location: location, completion: { (address) in
                
                if let city = address?.city{
                    self.lblPhotoInfo.text = "\(city) \n \(self.lblPhotoInfo.text!)"
                }
            })
        }
    }
    
    private func dismissPhotoViewer(){
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromBottom
        
        self.view.window?.layer.add(transition, forKey: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func displayImage(animationOptions:UIView.AnimationOptions){
        var _fetched:Bool = true
        
        self.timer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(PhotoViewerController.timeout), userInfo: nil, repeats: false)
        
        self.lblPhotoInfo.text = ""
        
        if let date = self.asset.creationDate{
            self.lblPhotoInfo.text = "\(date.toLocalString("dd MMMM yyyy hh:mm:ss a"))"
        }
        
        guard self.imgPhoto.image == nil else{
            self.timer.invalidate()
            return
        }
        
        if let pg = self.pvController as? PHPageViewController, let vm = pg.photoLibrary.vm{
            self.imgSelected.isHidden = vm.indexAsset(of: asset) == nil ? true : false
        }
        
        PHCacheManager.shared.startCachingPHAssets([self.asset], targetSize: self.imageSize, contentMode: .aspectFit, options: self.imageOptions)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.4) {
            self.showLoading = _fetched
        }
        
        PHCacheManager.shared.fetchAssetImage(asset: self.asset, targetSize: self.imageSize, mode: .aspectFit, options: self.imageOptions) { (image) in
            
            if let img = image{
                
                _fetched = false
                self.timer.invalidate()
                self.showLoading = false
                
                self.constPhotoHeight.constant = img.cgImage!.height >= Int(self.view.frame.height) ?
                    CGFloat(self.imageSize.height) : CGFloat(img.cgImage!.height)
                self.staticImageHeight = self.constPhotoHeight.constant
                
                UIView.animate(withDuration: 0.4, delay: 0, options: [UIView.AnimationOptions.allowUserInteraction], animations: {
               
                    self.imgPhoto.image = img
                }, completion: nil)
            }else{
                self.showLoading = false
                self.alert(title: Message.Error, message: Message.CannotLoadImage)
            }
        }
    }
    
    @objc private func timeout(){
        self.timer.invalidate()
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        let reload = UIAlertAction(title: "Reload", style: .destructive) { (action) in
            self.displayImage(animationOptions: [.transitionCrossDissolve])
            self.retrieveImageLocation()
        }
        
        self.alert(title: Message.TimeOut, message: Message.PhotoLoadTimeout, style: .alert, actions: [cancel, reload])
    }
    
    private func animateUserTapAction(){
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
            self.imgPopup.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.imgPopup.alpha = 1.0
        }) { (completed) in
            
            UIView.animateKeyframes(withDuration: 0.1, delay: 0, options: .allowUserInteraction, animations: {
                self.imgPopup.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: { (completed) in
                
                UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
                    self.imgPopup.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                    self.imgPopup.alpha = 0.0
                }, completion: { (completed) in
                    self.imgPopup.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
                
                self.imgSelected.isHidden = !self.imgSelected.isHidden
            })
        }
    }
    
    private func animateSelectedPhoto(){
        self.imgPopup.image = UIImage(named: "Like")
        self.animateUserTapAction()
    }
    
    private func animateUnselectedPhoto(){
        self.imgPopup.image = UIImage(named: "Dislike")
        self.animateUserTapAction()
    }
}

//MARK: - Extension
extension PhotoViewerController : UIScrollViewDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgPhoto
    }
}
