//
//  CommonPickerController.swift
//  CartonBox
//
//  Created by kay weng on 01/11/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit

protocol CommonPickerDelegate {
    func returnSelectedParameter(_ parameter:String, dismissPicker:Bool)
}

class CommonPickerController: UIViewController {

    @IBOutlet weak var dataPicker: UIPickerView!
    @IBOutlet weak var btnDone: UIButton!
    
    var parameters:[String]?
    var selectedIndex:Int?
    var delegate:CommonPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataPicker.dataSource = self
        self.dataPicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    @IBAction func onDoneSelection(_ sender: Any) {
        let selectedRow = dataPicker.selectedRow(inComponent: 0)
        let param = parameters![selectedRow]
        
        self.delegate?.returnSelectedParameter(param, dismissPicker: true)
    }
    
    //MARK: - Methods
    func setSelectedRow(selectedRowIndex:Int, inComponent componentIndex:Int){
        self.dataPicker.selectRow(selectedRowIndex, inComponent: componentIndex, animated: false)
    }
}

//MARK: - Extension
extension CommonPickerController : UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let p = parameters else {
            return 0
        }
        
        return p.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.parameters?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedRow = dataPicker.selectedRow(inComponent: component)
        let param = parameters![selectedRow]
        
        self.delegate?.returnSelectedParameter(param, dismissPicker: false)
    }
}
