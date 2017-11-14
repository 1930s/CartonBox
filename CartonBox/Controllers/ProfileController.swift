//
//  ProfileViewController.swift
//  CartonBox
//
//  Created by kay weng on 01/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import SnackKit

class ProfileController: BaseViewController {

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var vwFBUserProfile: FBSDKProfilePictureView!
    @IBOutlet weak var tblProfileInfo: UITableView!
    @IBOutlet var dtProfile: ProfileDataSource!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    var vw: ProfileViewModel!
    var datePicker = sb.instantiateViewController(withIdentifier: "DatePickerVC") as! DatePickerController
    var genderPicker = sb.instantiateViewController(withIdentifier: "CommonPickerVC") as! CommonPickerController
    var countryPicker = sb.instantiateViewController(withIdentifier: "CommonPickerVC") as! CommonPickerController

    override func viewDidLoad() {
        super.viewDidLoad()

        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(ProfileController.dismissViewController))
        
        self.vw = ProfileViewModel()

        self.vwFBUserProfile.profileID = appDelegate.facebookUser?.userId
        self.lblUserName.text = appDelegate.facebookUser?.userName ?? "Anonymous"
        
        self.datePicker.delegate = self
        
        self.genderPicker.delegate = self
        self.genderPicker.parameters = Parameters.getGenderList()
        
        self.countryPicker.delegate = self
        self.countryPicker.parameters = Parameters.getAllCountries()
        
        self.dtProfile.controller = self
        self.dtProfile.vw = self.vw
        self.dtProfile.datePicker = self.datePicker
        self.dtProfile.genderPicker = self.genderPicker
        self.dtProfile.countryPicker = self.countryPicker
        
        self.tblProfileInfo.delegate = dtProfile
        self.tblProfileInfo.dataSource = dtProfile
        self.tblProfileInfo.register(UINib(nibName: profileInfoCell, bundle: nil), forCellReuseIdentifier: profileInfoCell)
        self.tblProfileInfo.register(UINib(nibName: facebookCell, bundle: nil), forCellReuseIdentifier: facebookCell)
        
        dismissKeyboardTap.cancelsTouchesInView = false
        self.tblProfileInfo.addGestureRecognizer(dismissKeyboardTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func initScreenSetting() {
        self.vwFBUserProfile.circle()
        self.lblUserName.text = "Anonymous"
    }
    
    override func updateFacebookUserInfo(info: [String : AnyObject]) {
        
        if info.keys.first == FB_SDK_PROFILE_NEW{
            self.vwFBUserProfile.profileID = appDelegate.facebookUser!.userId
            self.lblUserName.text = appDelegate.facebookUser!.userName
            
            self.tblProfileInfo.reloadData()
        }else{
            self.vwFBUserProfile.profileID = ""
            self.lblUserName.text = "Anonymous"
        }
        
        self.tblProfileInfo.reloadData()
    }
    
    @objc func dismissViewController(){
        self.view.endEditing(true)
    }
    
    @IBAction func onSaveProfileInfo(_ sender: Any) {
        
        guard appDelegate.cartonboxUser != nil else {
            self.alert(title: "Invalid Info", message: "Invalid User Info.Please re-login.")
            return
        }
        
        //dob
        let dob = self.tblProfileInfo.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileInfoCell
        
        //gender
        let gender = self.tblProfileInfo.cellForRow(at: IndexPath(row: 1, section: 0)) as? ProfileInfoCell

        //email
        let email = self.tblProfileInfo.cellForRow(at: IndexPath(row: 2, section: 0)) as? ProfileInfoCell
        
        guard let _ = email, !email!.txtInfo.text!.isEmpty else{
            self.alert(title: "Email", message: "Please enter email address")
            return
        }
        
        //mobile
        let mobile = self.tblProfileInfo.cellForRow(at: IndexPath(row: 3, section: 0)) as? ProfileInfoCell
        
        guard let _  = mobile , !mobile!.txtInfo.text!.isEmpty else{
            self.alert(title: "Mobile Number", message: "Please enter mobile no.")
            return
        }
        
        //country
        let nationality = self.tblProfileInfo.cellForRow(at: IndexPath(row: 4, section: 0)) as? ProfileInfoCell
        
        appDelegate.cartonboxUser?._gender = gender?.txtInfo.text!
        appDelegate.cartonboxUser?._dob = dob?.txtInfo.text!
        appDelegate.cartonboxUser?._email = email!.txtInfo.text!
        appDelegate.cartonboxUser?._mobile = mobile!.txtInfo.text!
        appDelegate.cartonboxUser?._country = nationality?.txtInfo.text!
        appDelegate.cartonboxUser?._active = true
        appDelegate.cartonboxUser?._modifiedOn = Date().now.toLocalString(DateFormat.dateTime)
        
        vw.saveUserInfo(appDelegate.cartonboxUser!) { (success, message) in
            
            if success{
                self.alert(title: "Application", message: message)
            }else{
                self.alert(title: "Error", message: message)
            }
        }
    }
}

extension ProfileController: DatePickerDelegate{
    
    func returnSelectedDate(_ selectedDate: String) {
        
        let cell = self.tblProfileInfo.cellForRow(at:
            IndexPath(row: vw.arrCell.index(of: "Birthday")!, section: 0)) as! ProfileInfoCell
        
        cell.txtInfo.text = selectedDate
    }
}

extension ProfileController: CommonPickerDelegate{
    
    func returnSelectedParameter(_ selectedParameter: String) {
     
        if Parameters.getGenderList().contains(selectedParameter){
            
            let cell = self.tblProfileInfo.cellForRow(at:
                IndexPath(row: vw.arrCell.index(of: "Gender")!, section: 0)) as! ProfileInfoCell
            
            cell.txtInfo.text = selectedParameter
            cell.imgIcon.image = UIImage(named: vw.getGenderCellInfo(gender: selectedParameter).iconName)
        
        }else if Parameters.getAllCountries().contains(selectedParameter){
            
            let cell = self.tblProfileInfo.cellForRow(at:
                IndexPath(row: vw.arrCell.index(of: "Nationality")!, section: 0)) as! ProfileInfoCell
            
            cell.txtInfo.text = selectedParameter
            cell.imgIcon.image = UIImage(named: vw.getUserCellInfo(type: "Nationality").iconName)
        }
    }
}

extension ProfileController: FacebookCellDelegate{
    
    func openFacebookLoginView() {
        
        UIView.animate(withDuration: 1.5, animations: {
            self.present(super.facebookSigIn, animated: true, completion: nil)
        })
    }
}

extension ProfileController: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //Email
        if textField.tag == 3 {
         
            if !RegExpHelper.test(textField.text!, pattern: RegExp.Email){
                
                textField.text = ""
                textField.becomeFirstResponder()
                self.alert(title: "Invalid Email", message: "Pleasse enter a valid email address \nE.g: cartonbox@mail.com")
            }
        }
        
        //Mobile
        if textField.tag == 4{
            
            if !RegExpHelper.test(textField.text!, pattern: RegExp.Phone){
                
                textField.text = ""
                textField.becomeFirstResponder()
                self.alert(title: "Invalid Mobile Number", message: "Pleasse enter a valid mobile number \nE.g: 0123456789")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
