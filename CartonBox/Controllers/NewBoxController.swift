//
//  NewBoxController.swift
//  CartonBox
//
//  Created by kay weng on 01/12/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit
import Bond

let SegueOfReceipent = "SegueOfReceipent"
let SegueOfBoxFile = "SegueOfBoxFile"

class NewBoxController: UITableViewController {

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtvDescription: UITextView!
    @IBOutlet weak var vwReceipents: UIView!
    @IBOutlet weak var lblSelectedMediaCount: UILabel!
    @IBOutlet weak var lblStorageSize: UILabel!
    @IBOutlet weak var swPasscode: UISwitch!
    @IBOutlet weak var lblPasscode: UILabel!
    @IBOutlet weak var cellPasscode: UITableViewCell!
    
    var receipentVC:ReceipentController!
    lazy var passcodeView: PasscodeController = sb.instantiateViewController(withIdentifier: "PasscodeVC") as! PasscodeController
    lazy var vm:NewBoxViewModel = NewBoxViewModel()
    let descriptionPlaceHolder = "Enter Description Here"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(NewBoxController.dismissViewController))
        dismissKeyboardTap.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(dismissKeyboardTap)
        
        self.lblSelectedMediaCount.corner(rounding: UIRectCorner.allCorners)
        
        self.txtvDescription.tag = 1
        self.txtvDescription.delegate = self
        self.txtvDescription.text = descriptionPlaceHolder
        
        self.txtTitle.reactive.text.observeNext { (text) in
            self.vm.title = text
        }
        
        self.txtvDescription.reactive.text.observeNext { (text) in
            self.vm.description = text
        }
    
        self.lblSelectedMediaCount.text = "\(self.vm.media.count)"
        self.lblStorageSize.text = "\(self.vm.getMediaFileSize())"
        
        if let p = self.vm.passcode {
            self.lblPasscode.text = p
            self.cellPasscode.isHidden = false
        }else{
            self.cellPasscode.isHidden = true
        }
        
        self.passcodeView.modalPresentationStyle = .overCurrentContext
        self.passcodeView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.tabBarController?.tabBar.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    @objc func dismissViewController(){
        self.view.endEditing(true)
    }

    @IBAction func eraseBoxContent(_ sender: Any) {
        let btnOK = UIAlertAction(title: "OK", style: .destructive) { (action) in
            self.vm.clear()
            self.lblSelectedMediaCount.text = "\(self.vm.media.count)"
            self.lblStorageSize.text = "\(self.vm.getMediaFileSize())"
        }
        
        let btnCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert(title: Message.Application, message: Message.ResetNewBox, style: .alert, actions: [btnOK, btnCancel])
    }

    @IBAction func onPasscode(_ sender: Any) {
        
        if self.swPasscode.isOn{
            if self.vm.passcode == nil{
                UIView.animate(withDuration: 0.5, animations: {
                    self.present(self.passcodeView, animated: true, completion: nil)
                })
            }else{
                self.cellPasscode.isHidden = false
                self.lblPasscode.text = self.vm.passcode
            }
        }else{
            self.vm.passcode = nil
            self.cellPasscode.isHidden = true
        }
    }
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueOfReceipent{
            
            receipentVC = (segue.destination as! ReceipentController)
            receipentVC.vm = self.vm
            
            self.addChild(receipentVC)
        }else if segue.identifier == SegueOfBoxFile {
            
            let boxVC = segue.destination as! BoxContainerController
            boxVC.delegate = self
            
            if self.vm.media.count > 0 {
                boxVC.vm.populateSelectedMedia(self.vm.media)
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        return true
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        if identifier == SegueOfReceipent{
            receipentVC.vm.receipents = vm.receipents
            return
        }
    }
}

//MARK: - Extension
extension NewBoxController: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = textView.text == descriptionPlaceHolder ? "" : descriptionPlaceHolder
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.text = textView.text.count == 0 ? descriptionPlaceHolder : textView.text
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if !self.cellPasscode.isHidden && indexPath.section == 3 && indexPath.row == 1{
            //Open Passcode Controller
            self.present(self.passcodeView, animated: true, completion: nil)
        }
    }
}

extension NewBoxController : BoxContainerDelegate {
    
    func selectedMediaAsset(_ selectedAsset: [PHAssetMedia]) {
        self.vm.media.removeAll()
        self.vm.media = selectedAsset
        
        self.lblSelectedMediaCount.text = "\(self.vm.media.count)"
        self.lblStorageSize.text = "\(self.vm.getMediaFileSize())"
    }
}

extension NewBoxController : PasscodeDelegate{
    func returnPasscode(_ passcode: String?) {
        if let p = passcode {
            self.lblPasscode.text = p
            self.swPasscode.isOn = true
            self.cellPasscode.isHidden = false
        }
    }
    
    func cancelPasscode(){
        guard let _ = self.vm.passcode else{
            self.swPasscode.isOn = false
            self.cellPasscode.isHidden = true
            return
        }
    }
}
