//
//  BoxDetailTableViewController.swift
//  CartonBox
//
//  Created by kay weng on 17/11/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit

class BoxDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var lblNumberOfReceipents: UILabel!
    @IBOutlet weak var lblSelectMore: UILabel!
    @IBOutlet weak var viewReceipents: UIView!
    @IBOutlet weak var cellReceipents: UITableViewCell!
    @IBOutlet weak var cellFiles: UITableViewCell!
    @IBOutlet weak var viewFiles: UIView!
    
    var viewModel: BoxDetailViewModel!
    var selectedId:String?
    var isNew:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(BoxDetailTableViewController.dismissViewController))
        
        self.viewModel = BoxDetailViewModel()
        
        self.tableView.delegate = self
        self.navigationController?.title = isNew ? "New Box" : "Edit Box"
        
        dismissKeyboardTap.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(dismissKeyboardTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let row = indexPath.row
        let section = indexPath.section
        
        switch section{
        case 0:
            return row == 0 ? tableView.defaultCellHeight() : CGFloat(100)
        case 1:
            return row == 0 ? tableView.defaultCellHeight() : CGFloat(44 * self.viewModel!.receipents.count)
        case 2:
            return row == 0 ? tableView.defaultCellHeight() : CGFloat(44 * self.viewModel!.files.count)
        default:
            return tableView.defaultCellHeight()
        }
    }
    
    @objc func dismissViewController(){
        self.view.endEditing(true)
    }
}

//extension BoxDetailTableViewController{
//
//    func populateBoxDetail(){
//
//        if let id = self.selectedId {
//
//            self.viewModel.loadBoxDetail(id: id, completion: { (error) in
//
//                if let _ = error {
//
//                }else{
//
//                    self.txtTitle.text = self.viewModel.title
//                    self.txtDescription.text = self.viewModel.description
//                    self.lblNumberOfReceipents.text = "\(self.viewModel.receipents.count)"
//                }
//            })
//        }
//    }
//}

