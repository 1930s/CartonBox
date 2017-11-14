//
//  LoadingController.swift
//  CartonBox
//
//  Created by kay weng on 26/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit
import SnackKit

class LoadingController: UIViewController {

    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!
    @IBOutlet weak var lblLoadingText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        
        self.indicatorLoading.color = UIColor.brown
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func start(){
        
        indicatorLoading.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stop(){
        
        indicatorLoading.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
