//
//  ContainerController.swift
//  CartonBox
//
//  Created by kay weng on 10/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit

class ContainerController: UIViewController {

    var containerParent:UIViewController!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.performSegue(withIdentifier: "SegueOfPageView", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? FacebookInfoPageController{
            
            destination.pgFacebookInfo = (self.containerParent as? FacebookSignInController)?.pgFacebookInfo
            
            segue.destination.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width,height: self.view.frame.size.height)
            
            self.view.addSubview(destination.view)
        }
    }
}
