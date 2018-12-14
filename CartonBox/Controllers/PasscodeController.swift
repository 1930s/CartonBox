//
//  PasscodeController.swift
//  CartonBox
//
//  Created by kay weng on 09/12/2018.
//  Copyright © 2018 kay weng. All rights reserved.
//

import UIKit

protocol PasscodeDelegate {
    func returnPasscode(_ passcode: String?)
    func cancelPasscode()
}

class PasscodeController: UIViewController {

    @IBOutlet weak var vwPasscode: UIView!
    @IBOutlet weak var txtvDescription: UITextView!
    @IBOutlet weak var txtPasscode: UITextField!
    @IBOutlet weak var txtConfirmPasscode: UITextField!
    
    var delegate:PasscodeDelegate?
    var swPasscode:UISwitch?
    var passcode:String?
    var confirmPasscode:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(PasscodeController.dismissViewController))
        dismissKeyboardTap.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(dismissKeyboardTap)
        
        self.vwPasscode.corner(rounding: UIRectCorner.allCorners, size: CGSize(width: 10, height: 10))
        
        self.txtPasscode.reactive.text.observeNext { (text) in
            self.passcode = text
        }
        
        self.txtConfirmPasscode.reactive.text.observeNext { (text) in
            self.confirmPasscode = text
        }
        
        if let p = self.passcode {
            self.passcode = p
            self.confirmPasscode = p
        }
    }
    
    //MARK: - Actions
    @objc func dismissViewController(){
        self.view.endEditing(true)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.cancelPasscode()
        }
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        
        guard let _ = self.passcode else {
            self.alert(title: Message.Error, message: Message.EnterPasscode)
            return
        }
        
        guard let _ = self.confirmPasscode else {
            self.alert(title: Message.Error, message: Message.EnterPasscode)
            return
        }
        
        if self.passcode!.count < 4 {
            self.alert(title: Message.Error, message: Message.PasscodeLength)
            return
        }
        
        if self.passcode! != self.confirmPasscode! {
            self.alert(title: Message.Error, message: Message.EnterConfirmPasscode)
            return
        }
        
        self.dismiss(animated: true) {
            self.delegate?.returnPasscode(self.passcode)
        }
    }
}
