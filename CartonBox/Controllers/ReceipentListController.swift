//
//  ReceipentListController.swift
//  CartonBox
//
//  Created by kay weng on 20/11/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit

class ReceipentListController: UITableViewController {

    @IBOutlet var dtReceipents: ReceipentDataSource!
    
    var viewModel:ReceipentsViewModel!
    var emailTextField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(ReceipentListController.addNewReceipentEmail))

        self.viewModel = ReceipentsViewModel()
        
        self.emailTextField = UITextField()
        self.emailTextField.keyboardType = .emailAddress
        
        self.tableView.delegate = self.dtReceipents
        self.tableView.dataSource = self.dtReceipents
        self.tableView.register(UINib(nibName: receipentCell, bundle: nil), forCellReuseIdentifier: receipentCell)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ReceipentListController{
    
    @objc func addNewReceipentEmail(sender: UIBarButtonItem){
        
        self.alert(title: "Add Receipent", message: "Enter Receipent's Email", control: emailTextField)
    }
}
