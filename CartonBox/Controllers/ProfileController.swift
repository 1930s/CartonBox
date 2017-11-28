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
    
    var viewModel: ProfileViewModel!
    var datePicker = sb.instantiateViewController(withIdentifier: ControllerName.DatePickerVC) as! DatePickerController
    var genderPicker = sb.instantiateViewController(withIdentifier: ControllerName.CommonPicker) as! CommonPickerController
    var countryPicker = sb.instantiateViewController(withIdentifier: ControllerName.CommonPicker) as! CommonPickerController

    override func viewDidLoad() {
        super.viewDidLoad()

        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(ProfileController.dismissViewController))
    
        self.viewModel = ProfileViewModel()

        self.vwFBUserProfile.profileID = appDelegate.facebookUser?.userId
        self.lblUserName.text = appDelegate.facebookUser?.userName ?? Message.Anonymous
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.datePicker.delegate = self
        
        self.genderPicker.delegate = self
        self.genderPicker.parameters = Parameters.getGenderList()
        
        self.countryPicker.delegate = self
        self.countryPicker.parameters = Parameters.getAllCountries()
        
        self.dtProfile.controller = self
        self.dtProfile.vw = self.viewModel
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
        
        guard let _ = appDelegate.cartonboxUser else{
            self.alert(title: Message.Warning, message: Message.RequiredProfileInfo)
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func initScreenSetting() {
        self.vwFBUserProfile.circle()
        self.lblUserName.text = Message.Anonymous
    }
    
    override func updateFacebookUserInfo(info: [String : AnyObject]) {
        
        if info.keys.first == FB_SDK_PROFILE_NEW{
            self.vwFBUserProfile.profileID = appDelegate.facebookUser!.userId
            self.lblUserName.text = appDelegate.facebookUser!.userName
            
            self.tblProfileInfo.reloadData()
        }else{
            self.vwFBUserProfile.profileID = ""
            self.lblUserName.text = Message.Anonymous
        }
        
        self.tblProfileInfo.reloadData()
    }
    
    @objc func dismissViewController(){
        self.view.endEditing(true)
    }
    
    @IBAction func onSaveProfileInfo(_ sender: Any) {
        
        if !self.validateProfileInfo(){
            return
        }
        
        //dob
        let dob = self.tblProfileInfo.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileInfoCell
        
        //gender
        let gender = self.tblProfileInfo.cellForRow(at: IndexPath(row: 1, section: 0)) as? ProfileInfoCell

        //email
        let email = self.tblProfileInfo.cellForRow(at: IndexPath(row: 2, section: 0)) as? ProfileInfoCell
        
        guard let _ = email, !email!.txtInfo.text!.isEmpty else{
            self.alert(title: Message.Warning, message: Message.InvalidEmail)
            return
        }
        
        //mobile
        let mobile = self.tblProfileInfo.cellForRow(at: IndexPath(row: 3, section: 0)) as? ProfileInfoCell
        
        guard let _  = mobile , !mobile!.txtInfo.text!.isEmpty else{
            self.alert(title: Message.Warning, message: Message.InvalidMobile)
            return
        }
        
        //country
        let nationality = self.tblProfileInfo.cellForRow(at: IndexPath(row: 4, section: 0)) as? ProfileInfoCell
        
        if appDelegate.cartonboxUser == nil{
            appDelegate.cartonboxUser = User()//UserProfile first time created
        }
        
        appDelegate.cartonboxUser?._gender = gender?.txtInfo.text!
        appDelegate.cartonboxUser?._dob = dob?.txtInfo.text!
        appDelegate.cartonboxUser?._email = email!.txtInfo.text!
        appDelegate.cartonboxUser?._mobile = mobile!.txtInfo.text!
        appDelegate.cartonboxUser?._country = nationality?.txtInfo.text!
        appDelegate.cartonboxUser?._active = true
        appDelegate.cartonboxUser?._modifiedOn = Date().now.toLocalString(DateFormat.dateTime)
        
        viewModel.saveUserInfo(appDelegate.cartonboxUser!) { (success, message) in
            
            if success{
                self.alert(title: Message.Info, message: message)
            }else{
                self.alert(title: Message.Error, message: message)
            }
        }
    }
    
    func validateProfileInfo()->Bool{
     
        var completed = true

        for i in 0..<5{
            let cell = self.tblProfileInfo.cellForRow(at: IndexPath(row: i, section: 0)) as! ProfileInfoCell
            
            if let txt = cell.txtInfo.text, txt.isEmpty{
                completed = false
                break
            }
        }
        
        if !completed{
            self.alert(title: Message.Warning, message: Message.RequiredProfileInfo)
        }
        
        return completed
    }
}

extension ProfileController: DatePickerDelegate{
    
    func returnSelectedDate(_ selectedDate: String) {
        
        let cell = self.tblProfileInfo.cellForRow(at:
            IndexPath(row: viewModel.arrCell.index(of: "Birthday")!, section: 0)) as! ProfileInfoCell
        
        cell.txtInfo.text = selectedDate
    }
}

extension ProfileController: CommonPickerDelegate{
    
    func returnSelectedParameter(_ selectedParameter: String) {
     
        if Parameters.getGenderList().contains(selectedParameter){
            
            let cell = self.tblProfileInfo.cellForRow(at:
                IndexPath(row: viewModel.arrCell.index(of: "Gender")!, section: 0)) as! ProfileInfoCell
            
            cell.txtInfo.text = selectedParameter
            cell.imgIcon.image = UIImage(named: viewModel.getGenderCellInfo(gender: selectedParameter).iconName)
        
        }else if Parameters.getAllCountries().contains(selectedParameter){
            
            let cell = self.tblProfileInfo.cellForRow(at:
                IndexPath(row: viewModel.arrCell.index(of: "Nationality")!, section: 0)) as! ProfileInfoCell
            
            cell.txtInfo.text = selectedParameter
            cell.imgIcon.image = UIImage(named: viewModel.getUserCellInfo(type: "Nationality").iconName)
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
                self.alert(title: Message.Warning, message: Message.InvalidEmail)
            }
        }
        
        //Mobile
        if textField.tag == 4{
            
            if !RegExpHelper.test(textField.text!, pattern: RegExp.Phone){
                
                textField.text = ""
                textField.becomeFirstResponder()
                self.alert(title: Message.Warning, message: Message.InvalidMobile)
            }
        }
        
        //Nationality
        if textField.tag == 5{
            
            if let txt = textField.text, txt.isEmpty{
                
                textField.text = ""
                textField.becomeFirstResponder()
                self.alert(title: Message.Warning, message: Message.InvalidCountry)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
