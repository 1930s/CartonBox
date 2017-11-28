//
//  ActivityController.swift
//  CartonBox
//
//  Created by kay weng on 05/11/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit
import SnackKit

class ActivityController: BaseViewController {

    @IBOutlet var dtActivity: ActivityDataSource!
    @IBOutlet weak var tblActivity: UITableView!
    
    var vm: ActivityViewModel!
    var refresh: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vm = ActivityViewModel()
        self.refresh = UIRefreshControl()
        self.refresh.tintColor = UIColor.lightGray
        self.refresh.frame.size = CGSize(width: 16, height: 16)
        self.refresh.addTarget(self, action: #selector(ActivityController.reloadUserActivities), for: .valueChanged)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.dtActivity.controller = self
        self.dtActivity.vm = vm
        
        self.tblActivity.addSubview(self.refresh)
        self.tblActivity.delegate = dtActivity
        self.tblActivity.dataSource = dtActivity
        self.tblActivity.register(UINib(nibName: facebookActivityCell, bundle: nil), forCellReuseIdentifier: facebookActivityCell)
        self.tblActivity.register(UINib(nibName: noActivityCell, bundle: nil), forCellReuseIdentifier: noActivityCell)
       
        self.reloadUserActivities()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func reloadUserActivities(){
        
        guard NetworkHelper.isConnectedToNetwork() else {
            return
        }
        
        self.vm.loadUserActivities(numberOfRecord: 20) { (error) in
            self.tblActivity.reloadData()
            self.refresh.endRefreshing()
        }
    }
}
