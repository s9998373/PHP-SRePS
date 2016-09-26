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
            
            let exportButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: #selector(TransactionsTableViewController.exportToCSV));
            self.navigationItem.leftBarButtonItem = exportButtonItem;
        }
        self.tableView.rowHeight = 56
    }
    
    func refreshData(){
        transactionList = SalesDataSource.sharedManager.allTransactions()
        self.tableView.reloadData()
    }
    
    func exportToCSV(){
        print(SalesDataSource.sharedManager.exportToCSV())
    }
    
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

}

extension TransactionsTableViewController : AddTransactionTableViewControllerDelegate{
    func didAddTransaction(sender: AddTransactionTableViewController, transaction: Transaction?) {
        if (transaction != nil && transaction!.numberOfItems() > 0) {
            SalesDataSource.sharedManager.addTransaction(transaction!)
            refreshData()
        }
        sender.dismissViewControllerAnimated(true, completion: nil);
    }
}
