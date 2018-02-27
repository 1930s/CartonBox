//
//  VideoViewerController.swift
//  CartonBox
//
//  Created by kay weng on 31/01/2018.
//  Copyright © 2018 kay weng. All rights reserved.
//

import UIKit
import AVKit
import Photos
import SnackKit
import Player

class VideoViewerController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var vwVideo: UIView!
    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var imgPopup: UIImageView!
    @IBOutlet weak var lblLoading: UILabel!
    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!
    @IBOutlet weak var btnPlay: UIButton!
    
    var pvController:UIViewController?
    var asset:PHAsset!
    var tag:Int!
    var player:Player = Player()
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

        self.btnPlay.setImage(UIImage(named: self.player.autoplay ? "Pause" : "Play"), for: .normal)
        
        addGestures()
        initPlayer()
        
        self.showLoading = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadVideo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.player.stop()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    @IBAction func onPlay(_ sender: Any) {
   
        if self.player.playbackState == .playing{
            self.btnPlay.setImage(UIImage(named: "Pause"), for: .normal)
            self.player.pause()
        }else{
            self.btnPlay.setImage(UIImage(named: "Play"), for: .normal)
            self.player.playFromCurrentTime()
        }
    }
    
    @IBAction func onClose(_ sender: Any) {
        self.dismissVideoViewer()
    }
    
    @IBAction func doubleTap(_ sender: Any){
        
        guard !showLoading else {
            return
        }
        
        if let page = self.pvController as? PHPageViewController{
            
            if let videoLibrary = page.videoLibrary{
                let vm = videoLibrary.vm
                
                if let _ = vm?.selectedVideos.index(of: asset){
                    self.animateUnselectedVideo()
                    videoLibrary.onUnSelectedAsset(self.asset)
                }else{
                    self.animateSelectedVideo()
                    videoLibrary.onSelectedAsset(self.asset)
                }
            }
        }
    }
    
    @IBAction func swipeBottom(_ sender: Any){
        self.dismissVideoViewer()
    }
    
    // MARK : - Methods
    fileprivate func initPlayer() {
        
        self.player.playbackDelegate = self
        self.player.playbackDelegate = self
        self.player.view.frame = self.view.bounds
        
        self.addChildViewController(self.player)
        self.vwVideo.addSubview(self.player.view)
        
        self.vwVideo.sendSubview(toBack: self.player.view)
        self.vwVideo.bringSubview(toFront: self.imgPopup)
        
        self.player.didMove(toParentViewController: self)
    }
    
    fileprivate func addGestures() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(VideoViewerController.doubleTap))
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(VideoViewerController.swipeBottom))
        
        doubleTapGesture.numberOfTapsRequired = 2
        swipeDownGesture.direction = .down
        
        doubleTapGesture.delegate = self
        swipeDownGesture.delegate = self
        
        self.view.addGestureRecognizer(doubleTapGesture)
        self.view.addGestureRecognizer(swipeDownGesture)
    }
    
    private func loadVideo(){
        
        let options = PHAssetRequestOptions.GetPHVideoRequestOptions(mode: .automatic, allowNetworkAccess: true)
        
        if let pg = self.pvController as? PHPageViewController, let vm = pg.videoLibrary.vm{
            self.imgSelected.isHidden = vm.selectedVideos.index(of: asset) == nil ? true : false
        }
        
        PHCacheManager.shared.fetchAssetVideo(asset: self.asset, options: options) { (avAsset) in
            
            if let videoUrl = avAsset?.url{
                self.player.url = videoUrl
                self.player.playFromBeginning()
            }else{
                self.alert(title: Message.Error, message: Message.CannotLoadVideo)
            }
        }
    }
    
    private func dismissVideoViewer(){
        
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionFromBottom
        
        self.view.window?.layer.add(transition, forKey: nil)
        
        self.dismiss(animated: true, completion: nil)
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
    
    private func animateSelectedVideo(){
        self.imgPopup.image = UIImage(named: "Like")
        self.animateUserTapAction()
    }
    
    private func animateUnselectedVideo(){
        self.imgPopup.image = UIImage(named: "Dislike")
        self.animateUserTapAction()
    }
}

extension VideoViewerController: PlayerPlaybackDelegate {
    
    public func playerPlaybackWillStartFromBeginning(_ player: Player) {
    }
    
    public func playerPlaybackDidEnd(_ player: Player) {
        self.btnPlay.setImage(UIImage(named: "Play"), for: .normal)
    }
    
    public func playerCurrentTimeDidChange(_ player: Player) {
        let fraction = Double(player.currentTime) / Double(player.maximumDuration)
    
        //self._playbackViewController?.setProgress(progress: CGFloat(fraction), animated: true)
    }
    
    public func playerPlaybackWillLoop(_ player: Player) {
        //self._playbackViewController?.reset()
    }
    
}
