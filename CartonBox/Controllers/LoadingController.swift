//
//  LoadingController.swift
//  CartonBox
//
//  Created by kay weng on 26/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit

class LoadingController: UIViewController {

    @IBOutlet weak var vwLoading: UIView!
    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vwLoading.clipsToBounds = true
        self.vwLoading.corner(rounding: UIRectCorner.allCorners)
        
        self.indicatorLoading.style = .gray
        self.indicatorLoading.clipsToBounds = true
        self.indicatorLoading.color = UIColor.black
        
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods
    func start(){
        indicatorLoading.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stop(){
        indicatorLoading.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
