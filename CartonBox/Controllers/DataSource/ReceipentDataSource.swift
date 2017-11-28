//
//  ReceipentDataSource.swift
//  CartonBox
//
//  Created by kay weng on 20/11/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit

class ReceipentDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    var controller:ReceipentListController!
    var vm:ReceipentsViewModel!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let _ = vm else {
            return 0
        }
        
        return vm.receipents.count > 0 ? 1 : 0
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "To:"
    }
}
