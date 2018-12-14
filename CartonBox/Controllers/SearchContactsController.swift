//
//  SearchContactsController.swift
//  CartonBox
//
//  Created by kay weng on 05/12/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit
import ContactsUI
import SnackKit

protocol SearchContactsDelegate {
    func returnSelectedReceipets(_ receipents:[String])
}

class SearchContactsController: UIViewController{

    @IBOutlet weak var tblContacts: UITableView!
    @IBOutlet var dtContacts: ContactDataSource!
   
    var delegate:SearchContactsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btnDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(SearchContactsController.onDoneSearchContact))
        
        self.navigationItem.setRightBarButton(btnDone, animated: false)
        self.navigationItem.title = "Search Contacts"
        self.tabBarController?.hidesBottomBarWhenPushed = true
        
        initializeTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    @IBAction func onDoneSearchContact(sender: Any){
        
        self.delegate?.returnSelectedReceipets(self.dtContacts.selectedReceipents)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Methods
    fileprivate func initializeTable() {
        if(!self.dtContacts.initContactsWithEmail()){
            let setting = UIAlertAction(title: "Setting", style: .destructive, handler: { (action) in
                UIApplication.shared.open(AppUrl.settingUrl!, options: [:], completionHandler: nil)
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            })
            
            self.alert(title: Message.AccessDenied, message: Message.AccessDeniedContact, style: .alert, actions: [setting, cancel])
        }
        
        self.tblContacts.delegate = dtContacts
        self.tblContacts.dataSource = dtContacts
        self.tblContacts.register(UINib(nibName: contactEmailCell, bundle:nil), forCellReuseIdentifier: contactEmailCell)
        self.tblContacts.reloadData()
    }
    
}
