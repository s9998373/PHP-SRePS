//
//  TransactionsTableViewController.swift
//  PHP-SRePS
//
//  Created by Terry Lewis on 16/08/2016.
//  Copyright © 2016 swindp2. All rights reserved.
//

import UIKit

enum TransactionViewMode {
    case All
    case Specified
}

class TransactionsTableViewController: UITableViewController {
    var transactionList: NSArray!;
    let kCellIdentifier = "TransactionItemCell";
    var transactionViewMode: TransactionViewMode = TransactionViewMode.All
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (transactionViewMode == TransactionViewMode.All) {
            refreshData()
            
            let addButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(TransactionsTableViewController.addSaleItem));
            self.navigationItem.rightBarButtonItem = addButtonItem;
            
            let exportButtonItem = UIBarButtonItem.init(title: "Export", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TransactionsTableViewController.exportToCSV));
            self.navigationItem.leftBarButtonItem = exportButtonItem;
        }
        self.tableView.rowHeight = 56
    }
    
    /// Refreshes the data and table.
    func refreshData(){
        transactionList = SalesDataSource.sharedManager.allTransactions()
//        self.tableView.reloadData()
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    /// Backs the current database up and offers the ability to share it with system applications.
    func exportToCSV(){
        /*
        let backupLocation = SalesDataSource.sharedManager.exportToCSV()
        print("Saved backup to \(backupLocation)")
        
        if backupLocation != nil {
            let backupData = NSURL.fileURLWithPath(backupLocation!)
            let activityVC = UIActivityViewController(activityItems: [backupData], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
        */
        
        let csvString = SalesDataSource.sharedManager.createCSVUsingTransactions(transactionList)
        print(csvString)
        
        let exportPathURL = NSURL.fileURLWithPath(csvString)
        let activityVC = UIActivityViewController(activityItems: [exportPathURL], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    /// Presents the new transation controller.
    func addSaleItem(){
        print("Adding a new item.");
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("AddTransactionTableViewController") as! AddTransactionTableViewController;
        controller.delegate = self
        let nav = UINavigationController.init(rootViewController: controller);
        self.presentViewController(nav, animated: true, completion: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if ((transactionList == nil)) {
            return 0
        }
        return transactionList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:TransactionTableViewCell? = tableView.dequeueReusableCellWithIdentifier("TransactionItemCell") as! TransactionTableViewCell?
        
        let transaction:Transaction = transactionList[indexPath.row] as! Transaction
        
        cell?.textLabel?.text = transaction.dateString()
        cell?.priceLabel!.text = transaction.totalCostString()
        cell?.detailTextLabel!.text = transaction.numberOfItemsString()

        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let transaction:Transaction = transactionList[indexPath.row] as! Transaction
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("AddTransactionTableViewController") as! AddTransactionTableViewController;
        controller.delegate = self
        controller.currentTransaction = transaction
        let nav = UINavigationController.init(rootViewController: controller);
        self.presentViewController(nav, animated: true, completion: nil);
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let transaction:Transaction = transactionList[indexPath.row] as! Transaction
            SalesDataSource.sharedManager.removeTransaction(transaction)
            refreshData()
        }
    }

}

extension TransactionsTableViewController : AddTransactionTableViewControllerDelegate{
    
    /// Handle new transaction added.
    ///
    /// - parameter sender:      The view controller that added the transaction.
    /// - parameter transaction: The new transation.
    func didAddTransaction(sender: AddTransactionTableViewController, transaction: Transaction?) {
        if (transaction != nil) {
            SalesDataSource.sharedManager.addTransaction(transaction!)
            refreshData()
        }
        sender.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func didModifyTransaction(sender: AddTransactionTableViewController, transaction: Transaction?){
        didAddTransaction(sender, transaction: transaction)
    }
}
