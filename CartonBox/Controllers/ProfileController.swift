//
//  ProfileViewController.swift
//  CartonBox
//
//  Created by kay weng on 01/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Bond
import SnackKit

class ProfileController: BaseViewController {

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var vwFBUserProfile: FBSDKProfilePictureView!
    @IBOutlet weak var tblProfileInfo: UITableView!
    @IBOutlet var dtProfile: ProfileDataSource!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    var vm:ProfileViewModel = ProfileViewModel()
    let datePicker = sb.instantiateViewController(withIdentifier: ControllerName.DatePickerVC) as! DatePickerController
    let genderPicker = sb.instantiateViewController(withIdentifier: ControllerName.CommonPicker) as! CommonPickerController
    let countryPicker = sb.instantiateViewController(withIdentifier: ControllerName.CommonPicker) as! CommonPickerController
    
    let genders = Parameters.getGenderList()
    let countries = Parameters.getAllCountries()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        initializePickers()
        initializeTable()
        
        self.vwFBUserProfile.profileID = appDelegate.facebookUser?.userId
        self.lblUserName.text = appDelegate.facebookUser?.userName ?? Message.Anonymous
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let _ = appDelegate.cartonboxUser else{
            self.alert(title: Message.Info, message: Message.RequiredProfileInfo)
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Override Base
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
    
    override func enterForeground() {
        self.vwFBUserProfile.profileID = appDelegate.facebookUser?.userId
        self.lblUserName.text = appDelegate.facebookUser?.userName ?? Message.Anonymous
        
        self.tblProfileInfo.reloadData()
    }
    
    //MARK: - Methods
    fileprivate func bindViewModelInputs(){
        for i in 0..<5{
            let cell = self.tblProfileInfo.cellForRow(at: IndexPath(row: i, section: 0)) as! ProfileInfoCell
            
            cell.txtInfo.reactive.text.observeNext(with: { (text) in
                
                switch i{
                case 0:
                    self.vm.user?._dob = cell.txtInfo.text
                case 1:
                    self.vm.user?._gender = cell.txtInfo.text
                case 2:
                    self.vm.user?._email = cell.txtInfo.text
                case 3:
                    self.vm.user?._mobile = cell.txtInfo.text
                case 4:
                    self.vm.user?._country = cell.txtInfo.text
                default:
                    break
                }
            })
        }
    }
    
    fileprivate func initializeTable() {
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(ProfileController.dismissViewController))
        dismissKeyboardTap.cancelsTouchesInView = false
        
        self.dtProfile.controller = self
        self.dtProfile.vm = self.vm
        
        self.tblProfileInfo.addGestureRecognizer(dismissKeyboardTap)
        self.tblProfileInfo.separatorStyle = .none
        self.tblProfileInfo.delegate = dtProfile
        self.tblProfileInfo.dataSource = dtProfile
        self.tblProfileInfo.register(UINib(nibName: profileInfoCell, bundle: nil), forCellReuseIdentifier: profileInfoCell)
        self.tblProfileInfo.register(UINib(nibName: facebookCell, bundle: nil), forCellReuseIdentifier: facebookCell)
        self.tblProfileInfo.register(UINib(nibName: mobileCell, bundle: nil), forCellReuseIdentifier: mobileCell)
    }
    
    fileprivate func initializePickers() {
        datePicker.delegate = self
        
        genderPicker.delegate = self
        genderPicker.parameters = genders
        
        countryPicker.delegate = self
        countryPicker.parameters = countries
    }
    
    //MARK: - Actions
    @objc func dismissViewController(){
        self.view.endEditing(true)
    }
    
    @IBAction func onSaveProfileInfo(_ sender: UIBarButtonItem) {
        let dob = self.tblProfileInfo.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProfileInfoCell
        let gender = self.tblProfileInfo.cellForRow(at: IndexPath(row: 1, section: 0)) as? ProfileInfoCell
        let email = self.tblProfileInfo.cellForRow(at: IndexPath(row: 2, section: 0)) as? ProfileInfoCell
        let mobile = self.tblProfileInfo.cellForRow(at: IndexPath(row: 3, section: 0)) as? MobileCell
        let nationality = self.tblProfileInfo.cellForRow(at: IndexPath(row: 4, section: 0)) as? ProfileInfoCell
        
        guard let _ = dob, !dob!.txtInfo.text!.isEmpty else{
            self.alert(title: Message.Warning, message: Message.InvalidDOB)
            return
        }
        
        guard let _ = gender, !gender!.txtInfo.text!.isEmpty else{
            self.alert(title: Message.Warning, message: Message.InvalidGender)
            return
        }
        
        guard let _ = email, !email!.txtInfo.text!.isEmpty else{
            self.alert(title: Message.Warning, message: Message.InvalidEmail)
            return
        }
        
        guard let _  = mobile , !mobile!.txtInfo.text!.isEmpty else{
            self.alert(title: Message.Warning, message: Message.InvalidMobile)
            return
        }
        
        guard let _ = nationality , !nationality!.txtInfo.text!.isEmpty else{
            self.alert(title: Message.Warning, message: Message.InvalidCountry)
            return
        }
        
        appDelegate.showLoading { (hideLoading) in
            
            self.vm.saveUserInfo { (success, message) in
                hideLoading()
                self.alert(title: success ? Message.Info : Message.Warning, message: message)
            }
        }
    }
}

//MARK: - Extension
extension ProfileController: DatePickerDelegate{
    
    func returnSelectedDate(_ selectedDate: String) {
        let cell = self.tblProfileInfo.cellForRow(at: IndexPath(row: vm.arrCell.index(of: "Birthday")!, section: 0)) as! ProfileInfoCell
        
        cell.txtInfo.text = selectedDate
    }
}

extension ProfileController: CommonPickerDelegate{
    
    func returnSelectedParameter(_ parameter: String, dismissPicker: Bool) {
        if Parameters.getGenderList().contains(parameter){
            let genderCell = self.tblProfileInfo.cellForRow(at:
                IndexPath(row: vm.arrCell.index(of: "Gender")!, section: 0)) as! ProfileInfoCell
            
            genderCell.txtInfo.text = parameter
            genderCell.imgIcon.image = UIImage(named: vm.getGenderCellInfo(gender: parameter).iconName)
            
        }else if Parameters.getAllCountries().contains(parameter){
            let nationalityCell = self.tblProfileInfo.cellForRow(at:
                IndexPath(row: vm.arrCell.index(of: "Nationality")!, section: 0)) as! ProfileInfoCell
            let mobileCell = self.tblProfileInfo.cellForRow(at: IndexPath(row: vm.arrCell.index(of: "Mobile")!, section: 0)) as! MobileCell
            
            nationalityCell.txtInfo.text = parameter
            nationalityCell.imgIcon.image = UIImage(named: vm.getUserCellInfo(type: "Nationality").iconName)
            
            mobileCell.lblMobileCountryCode.text = Parameters.getMobileCountryCode(parameter)
        }
        
        if dismissPicker{
            self.view.endEditing(true)
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
