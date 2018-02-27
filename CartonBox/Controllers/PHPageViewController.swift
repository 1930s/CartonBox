//
//  PHPageViewController.swift
//  CartonBox
//
//  Created by kay weng on 18/01/2018.
//  Copyright © 2018 kay weng. All rights reserved.
//

import UIKit
import SnackKit
import Photos

class PHPageViewController: UIPageViewController, UIPageViewControllerDelegate {

    var photoLibrary:PhotoLibraryController!
    var videoLibrary:VideoLibraryController!
    var pages: [UIViewController]!
    var selectedAssetIndex:Int!
    
    var cacheOptions:PHImageRequestOptions = PHAssetRequestOptions.GetPHImageRequestOptions(mode: .highQualityFormat, isSynchronous: true, resizeMode: .none, allowNetworkAccess: true)
    var cacheAssets:[PHAsset] = []
    var firstLoad:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setViewControllers([pages[selectedAssetIndex]], direction: .forward, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

///MARK: - Extension
extension PHPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        self.firstLoad = false
    }
    
    @objc(pageViewController:willTransitionToViewControllers:) func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]){
     
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex - 1 < 0 ? pages.count - 1 : viewControllerIndex - 1
        
        guard nextIndex >= 0 else {
            return pages.last
        }
        
        return self.pages[nextIndex]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1 >= pages.count ? 0 : viewControllerIndex + 1
        
        guard pages.count != nextIndex else {
            return pages.first
        }
        
        return pages[nextIndex]
    }
    
}
