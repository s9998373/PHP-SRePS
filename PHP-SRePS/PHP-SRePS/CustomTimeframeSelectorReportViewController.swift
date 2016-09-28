//
//  CustomTimeframeSelectorReportViewController.swift
//  PHP-SRePS
//
//  Created by School on 20/09/2016.
//  Copyright © 2016 swindp2. All rights reserved.
//

import UIKit

class CustomTimeframeSelectorReportViewController: UIViewController {

    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentDate = NSDate()
        let yesterday = currentDate.dateByAddingTimeInterval(-(60 * 60 * 24))
        startDatePicker.date = yesterday
        endDatePicker.date = currentDate
        
        let nextButton = UIBarButtonItem.init(title: "Next", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CustomTimeframeSelectorReportViewController.nextButtonPressed))
        self.navigationItem.rightBarButtonItem = nextButton

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Obtains a set of transactions that meet the requirements of the predicate defined by the user.
    /// A TransactionTableViewController is then pushed, displaying this data.
    func nextButtonPressed(){
        let transactionsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TransactionsTableViewController") as! TransactionsTableViewController
        transactionsViewController.transactionViewMode = TransactionViewMode.Specified
        var dataSource:NSArray
        
        dataSource = SalesDataSource.sharedManager.transactionsBetweenDates(startDatePicker.date, end: endDatePicker.date)
        transactionsViewController.transactionList = dataSource
        self.navigationController?.pushViewController(transactionsViewController, animated: true)
    }

}
