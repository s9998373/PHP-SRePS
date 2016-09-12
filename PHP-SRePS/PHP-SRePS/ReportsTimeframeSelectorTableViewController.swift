//
//  ReportsTimeframeSelectorTableViewController.swift
//  PHP-SRePS
//
//  Created by School on 20/09/2016.
//  Copyright © 2016 swindp2. All rights reserved.
//

import UIKit

class ReportsTimeframeSelectorTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = self.storyboard
        if (indexPath.row == 2) {
            let customTimeframeViewController = storyboard?.instantiateViewControllerWithIdentifier("CustomTimeframeSelectorReportViewController")
            self.navigationController?.pushViewController(customTimeframeViewController!, animated: true)
        }else{
            let calendarTimeframeViewController = storyboard?.instantiateViewControllerWithIdentifier("CalendarTimeframeSelectorReportViewController") as! CalendarTimeframeSelectorReportViewController
            if (indexPath.row == 0) {
                calendarTimeframeViewController.timeframe = CalendarTimeframe.Weekly
            }else if (indexPath.row == 1){
                calendarTimeframeViewController.timeframe = CalendarTimeframe.Monthly
            }
            self.navigationController?.pushViewController(calendarTimeframeViewController, animated: true)
        }
    }

}
