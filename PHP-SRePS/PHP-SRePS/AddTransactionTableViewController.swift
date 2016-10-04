//
//  AddTransactionTableViewController.swift
//  PHP-SRePS
//
//  Created by Terry Lewis on 16/08/2016.
//  Copyright © 2016 swindp2. All rights reserved.
//

import UIKit

protocol AddTransactionTableViewControllerDelegate: class {
    func didAddTransaction(sender: AddTransactionTableViewController, transaction: Transaction?)
    func didModifyTransaction(sender: AddTransactionTableViewController, transaction: Transaction?)
}

class AddTransactionTableViewController: UITableViewController {
    weak var delegate: AddTransactionTableViewControllerDelegate!;
    var currentTransaction : Transaction!;
    var newTransaction:Bool = false
    let kCellIdentifier = "SalesEntryCellIdentifier";

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(AddTransactionTableViewController.dismiss));
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(AddTransactionTableViewController.doneAction));
        let flexibleSpaceItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil);
        let addProductButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(AddTransactionTableViewController.addProduct));
        self.navigationItem.rightBarButtonItem = doneButton;
        self.navigationItem.leftBarButtonItem = cancelButton;
        
        self.navigationController?.setToolbarHidden(false, animated: false)
        let buttons = [flexibleSpaceItem, addProductButton, flexibleSpaceItem];
        self.setToolbarItems(buttons, animated: true);
        self.toolbarItems = buttons;
    }
    
    
    /// Reload the table view.
    func reloadData(){
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    /// Display the new product view controller.
    func addProduct(){
        let controller = ProductsListTableViewController.init();
        controller.storyboardReference = self.storyboard;
        controller.delegate = self;
        let nav = UINavigationController.init(rootViewController: controller);
        self.presentViewController(nav, animated: true, completion: nil);
    }
    
    /// Generic method to dismiss the view controller.
    func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// Handle when the use taps done.
    func doneAction(){
        if newTransaction {
            self.delegate.didAddTransaction(self, transaction: currentTransaction)
        }else{
            self.delegate.didModifyTransaction(self, transaction: currentTransaction)
        }
    }
    
    /// Handles the user selecting a product in the product selection controller.
    ///
    /// - parameter selectedProduct:  The product that was selected.
    /// - parameter selectedQuantity: The quantity of the selected product.
    func handleSelectedProduct(selectedProduct: Product, selectedQuantity: Int){
        print("Selected ", selectedQuantity, " of ", selectedProduct.name, ".");
        if (currentTransaction == nil) {
            currentTransaction = Transaction(date: NSDate());
            newTransaction = true
        }else{
            newTransaction = false
        }
        
        let salesEntry = SalesEntry(product: selectedProduct, quanity: selectedQuantity);
        
        if (currentTransaction.doesProductExistInTransaction(selectedProduct)){
            handleDuplicateSalesEntry(salesEntry)
        }else{
            handleAdditionalSalesEntry(salesEntry)
        }
        
    }
    
    
    /// If the product already exists, allow the user to summate the total of products or input a new amount.
    ///
    /// - parameter salesEntry: The sales entry that is affected/already exists for a given product type.
    func handleDuplicateSalesEntry(salesEntry : SalesEntry){
        
        let alert = UIAlertController.init(title: "Information", message: "A sales entry for this product already exists. Do you wish to summate the existing and new quantities?", preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction.init(title: "Summate", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
            self.currentTransaction.mergeSalesEntry(salesEntry);
            self.reloadData()
        }));
        alert.addAction(UIAlertAction.init(title: "Replace", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction) in
            self.currentTransaction.removeSalesEntry(salesEntry)
            self.handleAdditionalSalesEntry(salesEntry)
        }));
        self.presentViewController(alert, animated: true, completion: nil);
    }
    
    
    /// Handles the case where a given SalesEntry to be added is unique.
    ///
    /// - parameter salesEntry: The SalesEntry to be added.
    func handleAdditionalSalesEntry(salesEntry : SalesEntry){
        currentTransaction.addSalesEntry(salesEntry)
        self.reloadData()
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
        if (currentTransaction == nil) {
            return 0
        }
        return currentTransaction.numberOfItems()
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell?
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: kCellIdentifier)
            //            cell = UITableViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: kCellIdentifier)
        }

        // Configure the cell...
        
        let currentItem = currentTransaction.salesEntryAtIndex(indexPath.row)
        cell!.textLabel?.text = currentItem.product!.name
        cell!.detailTextLabel!.text = String(currentItem.quantity!)

        return cell!
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let salesEntry = currentTransaction.salesEntryAtIndex(indexPath.row)
            print("Remove entry: \(currentTransaction.removeSalesEntry(salesEntry))")
            reloadData()
        }
    }

}

extension AddTransactionTableViewController : ProductsListTableViewControllerDelegate{
    func didSelectProduct(sender: ProductsListTableViewController, product: Product, selectedQuantity: Int) {
        sender.dismissViewControllerAnimated(true, completion: nil);
        handleSelectedProduct(product, selectedQuantity: selectedQuantity);
    }
}
