//
//  ReceipentDataSource.swift
//  CartonBox
//
//  Created by kay weng on 20/11/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit
import SnackKit

class ReceipentDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    var vm:NewBoxViewModel!
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSection = 0
        
        if vm.receipents.count > 0{
            tableView.backgroundView = nil
            numberOfSection = 1
        }else{
            let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            
            lbl.text = "No Receipent"
            lbl.textColor = UIColor.darkGray
            lbl.textAlignment = .center
            tableView.backgroundView = lbl
            tableView.separatorStyle = .none
            
            numberOfSection = 0
        }
        
        return numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.receipents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: receipentCell, for: indexPath) as! ReceipentCell
        
        cell.lblReceipentEmail.text = vm.receipents[row]
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(22.0)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(22.0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: receipentHeaderCell) as! ReceipentHeaderCell
            
            switch self.vm.receipents.count{
            case 0:
                view.lblTitle.text = ""
            case 1:
                view.lblTitle.text = "To : \(self.vm.receipents.count) receipent"
            default:
                view.lblTitle.text = "To : \(self.vm.receipents.count) receipents"
            }
            
            return view
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {    
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexPath) in
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.vm.receipents.remove(at: indexPath.row)
            
            if self.vm.receipents.count <= 0{
                tableView.removeSections(at: [indexPath.section])
            }else{
                tableView.updateRows(at: [indexPath], action: TableAction.Delete)
            }
            
            tableView.reloadData()
        }
        
        return [delete]
    }
}
