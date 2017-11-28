//
//  BoxViewController.swift
//  CartonBox
//
//  Created by kay weng on 17/11/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit

class BoxViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if segue.identifier == "NewBoxSegue" {
            
            let destination = segue.destination as! BoxDetailTableViewController
            destination.isNew = true
        }
    }
}
