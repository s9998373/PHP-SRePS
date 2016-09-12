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
        switch indexPath.row {
        case 0:
            
            break
        case 1:
            break
        case 2:
            let customTimeframeViewController = storyboard?.instantiateViewControllerWithIdentifier("CustomTimeframeSelectorReportViewController")
            self.navigationController?.pushViewController(customTimeframeViewController!, animated: true)
            
            break
        default:
            break
        }
    }

}
