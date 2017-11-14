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
    
    var delegate:DatePickerDelegate?
    var df:DateFormatter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.df = DateFormatter()
        self.df.dateFormat = DateFormat.dateBeautify

        self.dtCalander.datePickerMode = .date
        self.dtCalander.date = Date().now.add(years: -18)
        self.dtCalander.minimumDate = Date().now.add(years: -80)
        self.dtCalander.maximumDate =  Date().now.add(years: -5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPickerValueChanged(_ sender: Any) {
        self.delegate?.returnSelectedDate(df.string(from: dtCalander.date))
    }
}
