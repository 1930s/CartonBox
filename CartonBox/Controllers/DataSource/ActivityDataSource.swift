//
//  ActivityDataSource.swift
//  CartonBox
//
//  Created by kay weng on 05/11/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import Foundation
import UIKit
import SnackKit

class ActivityDataSource : NSObject, UITableViewDataSource, UITableViewDelegate{
    
    var vm:ActivityViewModel!
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if Array(vm.activityList.keys).count > 0{
            return Array(vm.activityList.keys).count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if Array(vm.activityList.values).count > 0{
            
            let _ = Array(vm.activityList.keys)[section]
            
            switch section{
            case 0:
                return vm.activityList["Today"]!.count == 0 ? 1 : vm.activityList["Today"]!.count
            default:
                if Array(vm.activityList.keys).contains("Yesterday"){
                    return section == 1 ? vm.activityList["Yesterday"]!.count : vm.activityList["Past"]!.count
                }else{
                    return vm.activityList["Past"]!.count
                }
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let section = indexPath.section
        let row = indexPath.row

        var key = ""
        
        switch section{
        case 0:
            key = "Today"
        default:
            if Array(vm.activityList.keys).contains("Yesterday"){
                key = section == 1 ? "Yesterday" : "Past"
            }else{
                key = "Past"
            }
        }
        
        if let data = vm.activityList[key], vm.activityList[key]!.count > 0 {
            
            let activity = data[row]
            let createdOn = DateFormat.GetDate(from: activity._createdOn!)
            
            if let enumType = UserAcitvityEnum(rawValue: activity._type!){
                
                switch enumType{
                case .FacebookLogin, .FacebookLogout:
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: facebookActivityCell, for: indexPath) as! FacebookActivityCell
                    
                    cell.imgIcon.image = getIconImage(type: enumType)
                    cell.txtMessage.text = activity._message
                    cell.constMessageBottom.constant = CGFloat(30)
                    
                    switch key{
                    case "Today":
                        cell.lblTimeStamp.text = createdOn!.elapsedMinuteFrom(Date().now)/60 == 0 ?
                            "\(createdOn!.elapsedMinuteFrom(Date().now)) minutes ago" : "\(createdOn!.elapsedMinuteFrom(Date().now)/60) hours ago"
                    case "Yesterday":
                        cell.lblTimeStamp.text = createdOn?.toLocalString(DateFormat.time)
                    case "Past":
                        cell.lblTimeStamp.text = "\(createdOn!.toLocalString(DateFormat.dayName)), \(createdOn!.toLocalString(DateFormat.dayMonth)) at \(createdOn!.toLocalString(DateFormat.time))"
                    default:
                        cell.lblTimeStamp.text = ""
                    }
                    
                    return cell
                }
            }
        }
        
        //No activity message cell
        let cell = tableView.dequeueReusableCell(withIdentifier: noActivityCell, for: indexPath) as! NoActivityCell
        
        cell.lblMessage.text = "You have no activity today"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if Array(vm.activityList.keys).count > 0{
            
            var title = ""
            
            switch section{
            case 0:
                title = "Today"
            default:
                if Array(vm.activityList.keys).contains("Yesterday"){
                    title = section == 1 ? "Yesterday" : "Past"
                }else{
                    title = "Past"
                }
            }
            
            return title
        }
        
        return nil
    }
    
    private func getIconImage(type:UserAcitvityEnum)->UIImage{
        
        switch  type {
        case .FacebookLogin:
            return UIImage(named: "Login")!
        case .FacebookLogout:
            return UIImage(named: "Logout")!
        }
    }
}
