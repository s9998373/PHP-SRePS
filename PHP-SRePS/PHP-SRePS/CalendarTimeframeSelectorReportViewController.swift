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
    var selectedYearRow:Int = 0, selectedCustomDataRow: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarComponentPicker.delegate = self
        calendarComponentPicker.dataSource = self
        populateComponentPicker()
        // Do any additional setup after loading the view.
    }
    
    func setTimeframe(timeframe:CalendarTimeframe){
        self.timeframe = timeframe
    }
    
    func populateComponentPicker(){
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        calendar.minimumDaysInFirstWeek = 4
        let components = calendar.components([.WeekOfYear , .Month , .Year], fromDate: date)
        
        let currentYear =  components.year
        let currentMonth = components.month
        let currentWeekOfYear = components.weekOfYear
        
        years = [String]()
        for year in 0..<67{
            let adjustedYear = year + 1970
            years.append(String(adjustedYear))
            if (currentYear - 1 == adjustedYear) {
                selectedYearRow = year
            }
        }
        if (timeframe == CalendarTimeframe.Weekly) {
            customData = [String]()
            for week in 1..<53{
                customData.append(String(week))
                if (currentWeekOfYear - 1 == week) {
                    selectedCustomDataRow = week
                }
            }
        }else{
            customData = [String]()
            let dateFormatter = NSDateFormatter.init()
            dateFormatter.locale = NSLocale.currentLocale()
            
            for month in 0..<12{
                let monthString = dateFormatter.standaloneMonthSymbols[month] as String?
                print(monthString)
                customData.append(monthString!)
                if (currentMonth - 1 == month) {
                    selectedCustomDataRow = month
                }
            }
        }
        
        self.calendarComponentPicker.reloadAllComponents()
        self.calendarComponentPicker.selectRow(selectedCustomDataRow, inComponent: 0, animated: false)
        self.calendarComponentPicker.selectRow(selectedYearRow, inComponent: 1, animated: false)
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
