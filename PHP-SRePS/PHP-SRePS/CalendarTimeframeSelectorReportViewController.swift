//
//  CalendarTimeframeSelectorReportViewController.swift
//  PHP-SRePS
//
//  Created by School on 20/09/2016.
//  Copyright © 2016 swindp2. All rights reserved.
//

import UIKit

enum CalendarTimeframe {
    case Weekly
    case Monthly
}

class CalendarTimeframeSelectorReportViewController: UIViewController {
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var calendarComponentPicker: UIPickerView!
    
    var years:Array<String>!
    var customData:Array<String>!
    var timeframe:CalendarTimeframe = CalendarTimeframe.Monthly

    override func viewDidLoad() {
        super.viewDidLoad()
        populateComponentPicker()
        // Do any additional setup after loading the view.
    }
    
    func populateComponentPicker(){
        years = []
        for year in 0..<67{
            years[year] = String(year + 1970);
        }
        if (timeframe == CalendarTimeframe.Weekly) {
            customData = []
            for week in 1..<52{
                customData[week - 1] = String(week)
            }
        }else{
            let dateFormatter = NSDateFormatter()
            for month in 0..<12{
                customData[month] = dateFormatter.monthSymbols[month]
            }
        }
        
        self.calendarComponentPicker.reloadAllComponents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CalendarTimeframeSelectorReportViewController : UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == 0) {
            return customData.count
        }else{
            return years.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (component == 0) {
            return customData[row]
        }else{
            return years[row]
        }
    }
    
}
