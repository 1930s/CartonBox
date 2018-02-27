//
//  ContactDataSource.swift
//  CartonBox
//
//  Created by kay weng on 05/12/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//


import UIKit
import ContactsUI
import SnackKit

class ContactDataSource: NSObject,UITableViewDataSource, UITableViewDelegate {

    var alphabets:[String]!
    var filterContacts:Dictionary<String, [CNContact]>!
    var selectedReceipents:[String]!
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let _ = alphabets else{
            return 0
        }
        
        return alphabets!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let key = self.alphabets![section]
        
        return self.filterContacts![key]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let section = indexPath.section
        
        let cell = tableView.dequeueReusableCell(withIdentifier: contactEmailCell, for: indexPath) as! ContactEmailCell
        let key = self.alphabets![section]
        let contact:CNContact = self.filterContacts![key]![row]
        let email = contact.emailAddresses[0].value as String
        
        var displayName = ""
        
        //Contact Name
        if !contact.familyName.isEmpty{
            displayName += contact.familyName
            displayName += " "
        }
        
        if !contact.givenName.isEmpty{
            displayName += contact.givenName
            displayName += " "
        }
        
        //Company Name
        if displayName.isEmpty{
            displayName = contact.organizationName
        }

        cell.lblName.bold(displayName)
        cell.lblEmail.text = email
        cell.selectionStyle = .none
        cell.accessoryType = self.selectedReceipents.contains(email) ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.alphabets![section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath) as! ContactEmailCell
        let email = cell.lblEmail.text!
  
        if selectedReceipents.contains(email){
            if let index = self.selectedReceipents.index(of: email) {
                self.selectedReceipents.remove(at: index)
                cell.accessoryType = .none
            }
        }else{
            self.selectedReceipents.append(email)
            cell.accessoryType = .checkmark
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.alphabets
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return self.alphabets.index(of: title)!
    }
    
    // MARK: - Method
    func initContactsWithEmail(){
        
        var contacts:[CNContact] = []
        
        self.alphabets = []
        self.filterContacts = Dictionary<String, [CNContact]>()
        
        if let allContacts = ContactStore.findContacts(), allContacts.count > 0 {
            
            for contact in allContacts{
                if contact.emailAddresses.count > 0{
                    contacts.append(contact)
                }
            }
        }
        
        for contact in contacts{
            //Get Alphabet
            var char = ""
            
            if !contact.familyName.isEmpty{
                char = contact.familyName[1]
            }else if !contact.givenName.isEmpty{
                char = contact.givenName[1]
            }else if !contact.middleName.isEmpty{
                char = contact.middleName[1]
            }else{
                char = "#"
            }
            
            if !char.isEmpty && !self.alphabets.contains(char){
                self.alphabets.append(char)
                self.filterContacts[char] = []
            }
            
            self.filterContacts[char]?.append(contact)
        }
        
        self.alphabets.sort(by: { $0 < $1})
    }
}
