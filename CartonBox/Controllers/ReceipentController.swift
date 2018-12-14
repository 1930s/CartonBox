//
//  ReceipentController.swift
//  CartonBox
//
//  Created by kay weng on 02/12/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit
import SnackKit

class ReceipentController: UIViewController {

    @IBOutlet weak var tblReceipent: UITableView!
    @IBOutlet weak var tbrActions: UIToolbar!
    @IBOutlet weak var bbtSearch: UIBarButtonItem!
    @IBOutlet weak var bbtQuickAdd: UIBarButtonItem!
    @IBOutlet var dtReceipents: ReceipentDataSource!
    
    var vm:NewBoxViewModel!
    
    fileprivate func initializeTable() {
        self.dtReceipents.vm = self.vm
        
        self.tblReceipent.delegate = dtReceipents
        self.tblReceipent.dataSource = dtReceipents
        self.tblReceipent.register(UINib(nibName: receipentCell, bundle:nil), forCellReuseIdentifier: receipentCell)
        self.tblReceipent.register(UINib(nibName: noActivityCell, bundle:nil), forCellReuseIdentifier: noActivityCell)
        self.tblReceipent.register(UINib(nibName: receipentHeaderCell, bundle:nil), forHeaderFooterViewReuseIdentifier: receipentHeaderCell)
        self.tblReceipent.tableFooterView = UIView(frame: CGRect.zero)
        self.tblReceipent.allowsMultipleSelectionDuringEditing = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    @IBAction func searchContact(_ sender: Any) {
        let searchContactVC = sb.instantiateViewController(withIdentifier: ControllerName.SearchContactVC) as! SearchContactsController
        
        searchContactVC.delegate = self
        searchContactVC.dtContacts.selectedReceipents = self.vm.receipents
        
        self.navigationController?.pushViewController(searchContactVC, animated: true)
    }
    
    @IBAction func addQuickReceipent(_ sender: Any) {
        var alertController:UIAlertController!
        let emailTextField = UITextField()
        
        emailTextField.keyboardType = .emailAddress

        let ok = UIAlertAction(title: "Add", style: .default) { (action) in

            let txt = alertController.textFields![0]
            
            if RegExpHelper.test(txt.text!, pattern: RegExp.Email){
                self.vm.receipents.append(txt.text!)
                self.reloadReceipentList()
            }else{
                self.alert(title: Message.Warning, message: Message.InvalidEmail)
                txt.text = ""
            }
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController = self.alert(title: "Add New Receipent", message: Message.InvalidEmail, actions: [ok, cancel], textfields: [emailTextField])
    }
    
    
    //MARK: - Methods
    func reloadReceipentList(){
        if self.vm.receipents.count > 0{
            self.tblReceipent.reloadSections(at: [0])
        }else if self.tblReceipent.numberOfSections > 0 && self.tblReceipent.numberOfRows(inSection: 0) > 0{
            self.tblReceipent.removeSections(at: [0])
        }
    }
}

//MARK: - Extension
extension ReceipentController: SearchContactsDelegate{
    
    func returnSelectedReceipets(_ receipents: [String]) {
        self.vm.receipents = receipents
        self.reloadReceipentList()
    }
}
