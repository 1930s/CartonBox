//
//  BoxFilesController.swift
//  CartonBox
//
//  Created by kay weng on 18/12/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PHAssetsController: ButtonBarPagerTabStripViewController {

    var mediaViewModel: MediaFilesViewModel!
    
    override func viewDidLoad() {

        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = .lightGray
        settings.style.buttonBarItemFont = .systemFont(ofSize: 15)
        settings.style.selectedBarHeight = 2
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let photoLibraryPage = sb.instantiateViewController(withIdentifier: "PhotoLibraryVC") as! PhotoLibraryController
        let videoLibraryPage = sb.instantiateViewController(withIdentifier: "VideoLibraryVC") as! VideoLibraryController
        
        photoLibraryPage.vm = self.mediaViewModel
        videoLibraryPage.vm = self.mediaViewModel
        
        
        return [photoLibraryPage,videoLibraryPage]
    }
    
    // MARK: - Update title
    func updateIndicatorTitle(title:String){
        
        
    }
}
