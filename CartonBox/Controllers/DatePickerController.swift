//
//  DatePickerController.swift
//  CartonBox
//
//  Created by kay weng on 31/10/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit

protocol DatePickerDelegate {
    
    func returnSelectedDate(_ selectedDate:String)
}

class DatePickerController: UIViewController {

    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var dtCalander: UIDatePicker!
    @IBOutlet weak var btnDone: UIButton!
    
    var delegate:DatePickerDelegate?
    var dateFormatter:DateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeDatePicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    @IBAction func onDoneSelection(_ sender: Any) {
        self.delegate?.returnSelectedDate(dateFormatter.string(from: dtCalander.date))
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onPickerValueChanged(_ sender: Any) {
        self.delegate?.returnSelectedDate(dateFormatter.string(from: dtCalander.date))
    }
    
    //MARK: - Methods
    fileprivate func initializeDatePicker() {
        self.dateFormatter.dateFormat = DateFormat.dateBeautify

        self.dtCalander.datePickerMode = .date
        self.dtCalander.date = Date().now.add(years: -18)
        self.dtCalander.minimumDate = Date().now.add(years: -80)
        self.dtCalander.maximumDate =  Date().now.add(years: -5)
    }
}
