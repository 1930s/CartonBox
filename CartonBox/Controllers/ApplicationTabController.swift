//
//  ApplicationTabController.swift
//  CartonBox
//
//  Created by kay weng on 28/11/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit

class ApplicationTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ApplicationTabController: UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
//        let homeVC = tabBarController.viewControllers![0]
//        let boxVC = tabBarController.viewControllers![1] as! BoxViewController
//        let activityVC = tabBarController.viewControllers![2] as! ActivityController
        let profileVC = tabBarController.viewControllers![3].childViewControllers[0] as! ProfileController
        
        //If selected tab is profile; no profile validation is needed
        if viewController == tabBarController.viewControllers![3]{
            return true
        }
        
        //Goto Profile is user info is not setup
        guard let _ = appDelegate.cartonboxUser else {
            profileVC.viewWillAppear(false)
            tabBarController.selectedIndex = 3
            return false
        }

        return true
    }
}
