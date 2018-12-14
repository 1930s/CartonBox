//
//  ActivityController.swift
//  CartonBox
//
//  Created by kay weng on 05/11/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit
import CoreGraphics
import SnackKit

class ActivityController: BaseViewController {

    @IBOutlet var dtActivity: ActivityDataSource!
    @IBOutlet weak var tblActivity: UITableView!

    var vm: ActivityViewModel =  ActivityViewModel()
    var refresh:UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        initializeRefreshControl()
        initializeTable()
        reloadUserActivities()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    @objc func reloadUserActivities(){
        guard NetworkHelper.isConnectedToNetwork() else {
            return
        }
        
        appDelegate.showLoading { (hideLoading) in
            self.vm.loadUserActivities(numberOfRecord: 20) { (error) in
                self.tblActivity.reloadData()
                self.refresh.endRefreshing()
                hideLoading()
            }
        }
    }
    
    //MARK: - Methods
    fileprivate func initializeRefreshControl() {
        refresh.tintColor = UIColor.lightGray
        refresh.frame.size = CGSize(width: 16, height: 16)
        refresh.addTarget(self, action: #selector(ActivityController.reloadUserActivities), for: .valueChanged)
        
        self.tblActivity.addSubview(refresh)
    }
    
    
    fileprivate func initializeTable() {
        self.dtActivity.vm = vm
        self.tblActivity.delegate = dtActivity
        self.tblActivity.dataSource = dtActivity
        self.tblActivity.register(UINib(nibName: facebookActivityCell, bundle: nil), forCellReuseIdentifier: facebookActivityCell)
        self.tblActivity.register(UINib(nibName: noActivityCell, bundle: nil), forCellReuseIdentifier: noActivityCell)
    }
    
}
