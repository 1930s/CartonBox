//
//  ProfileDataSource.swift
//  CartonBox
//
//  Created by kay weng on 31/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation
import UIKit

public class ProfileDataSource : NSObject, UITableViewDataSource,UITableViewDelegate{
    
    var controller:ProfileController!
    var vm: ProfileViewModel!
   
    //MARK: - UITableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? vm.arrCell.count : 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        var profileInfo:ProfileCellInfo!
        
        if vm.arrCell[row] == "Gender"{
            profileInfo = vm.getGenderCellInfo(gender: appDelegate.cartonboxUser?._gender)
        }else {
            profileInfo = vm.getUserCellInfo(type: vm.arrCell[row])
        }
        
        if section == 0 && vm.arrCell[row] != "Mobile" {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: profileInfoCell, for: indexPath) as! ProfileInfoCell
            
            cell.selectionStyle = .none
            cell.imgIcon.image = UIImage(named: profileInfo.iconName)
            
            cell.txtInfo.tag = profileInfo.tag
            cell.txtInfo.text = profileInfo.data
            cell.txtInfo.placeholder = profileInfo.placeholder
            cell.txtInfo.delegate = self.controller
            
            switch vm.arrCell[row]{
            case "Email":
                cell.txtInfo.keyboardType = .emailAddress
                
                cell.txtInfo.reactive.text.observeNext(with: { (text) in
                    self.vm.user?._email = text
                })
                
            case "Birthday":
                cell.txtInfo.inputView = controller.datePicker.view
                
                cell.txtInfo.reactive.text.observeNext(with: { (text) in
                    self.vm.user?._dob = text
                })
                
            case "Gender":
                cell.txtInfo.inputView = controller.genderPicker.view
                
                cell.txtInfo.reactive.text.observeNext(with: { (text) in
                    self.vm.user?._gender = text
                })
                
                if let gender = profileInfo.data, let index = controller.countries.index(of: gender){
                    controller.genderPicker.setSelectedRow(selectedRowIndex: index, inComponent: 0)
                }
                
            case "Nationality":
                cell.txtInfo.inputView = controller.countryPicker.view
                
                cell.txtInfo.reactive.text.observeNext(with: { (text) in
                    self.vm.user?._country = text
                })
                
                if let country = profileInfo.data, let index = controller.countries.index(of: country){
                    controller.countryPicker.setSelectedRow(selectedRowIndex: index, inComponent: 0)
                }
                
            default:
                cell.txtInfo.keyboardType = .asciiCapable
            }
            
            return cell
        }else if vm.arrCell[row] == "Mobile"{
            let mcell = tableView.dequeueReusableCell(withIdentifier: mobileCell, for: indexPath) as! MobileCell
            
            mcell.selectionStyle = .none
            
            mcell.txtInfo.tag = profileInfo.tag
            mcell.txtInfo.text = profileInfo.data
            mcell.txtInfo.placeholder = profileInfo.placeholder
            mcell.txtInfo.delegate =  self.controller
            
            mcell.txtInfo.keyboardType = .phonePad
            
            mcell.txtInfo.reactive.text.observeNext(with: { (text) in
                self.vm.user?._mobile = text
            })
            
            return mcell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: facebookCell, for: indexPath) as! FacebookCell
            
            if let _ = appDelegate.facebookUser, appDelegate.facebookUser!.activeSession{
                cell.btnLogout.titleLabel?.text = "Logout"
            }else{
                cell.btnLogout.titleLabel?.text = "Login"
            }

            cell.delegate = self.controller
            cell.indentationWidth = -10000
            cell.indentationLevel = -1
            
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Info" : ""
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
}
