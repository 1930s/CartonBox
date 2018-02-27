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
    
    var receipentVC:ReceipentController!
    var vm:NewBoxViewModel = NewBoxViewModel()
    
    let descriptionPlaceHolder = "Enter Description Here"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(NewBoxController.dismissViewController))
        dismissKeyboardTap.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(dismissKeyboardTap)
        
        self.txtvDescription.tag = 1
        self.txtvDescription.delegate = self
        self.txtvDescription.text = descriptionPlaceHolder
        
        self.txtTitle.reactive.text.observeNext { (text) in
            self.vm.title = text
        }
        
        self.txtvDescription.reactive.text.observeNext { (text) in
            self.vm.description = text
        }
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

    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueOfReceipent{
            
            receipentVC = segue.destination as! ReceipentController
            receipentVC.vm = self.vm
            
            self.addChildViewController(receipentVC)
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
}
