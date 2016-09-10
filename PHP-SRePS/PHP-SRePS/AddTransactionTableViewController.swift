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
}

class AddTransactionTableViewController: UITableViewController {
    weak var delegate: AddTransactionTableViewControllerDelegate!;
    var currentTransaction : Transaction!;
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func reloadData(){
//        self.tableView.reloadData()
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func addProduct(){
        let controller = ProductsListTableViewController.init();
        controller.storyboardReference = self.storyboard;
        controller.delegate = self;
        let nav = UINavigationController.init(rootViewController: controller);
//        self.navigationController?.pushViewController(controller, animated: true);
        self.presentViewController(nav, animated: true, completion: nil);
    }
    
    func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func doneAction(){
        self.delegate.didAddTransaction(self, transaction: currentTransaction)
//        self.dismiss()
    }
    
    func handleSelectedProduct(selectedProduct: Product, selectedQuantity: Int){
        print("Selected ", selectedQuantity, " of ", selectedProduct.name, ".");
        if (currentTransaction == nil) {
            currentTransaction = Transaction(date: NSDate());
        }
        
        let salesEntry = SalesEntry(product: selectedProduct, quanity: selectedQuantity);
//        salesEntry.product = selectedProduct
//        salesEntry.quantity = selectedQuantity
        
        if (currentTransaction.doesProductExistInTransaction(selectedProduct)){
            handleDuplicateSalesEntry(salesEntry)
        }else{
            handleAdditionalSalesEntry(salesEntry)
        }
        
    }
    
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
        cell!.detailTextLabel!.text = String(currentItem.quantity)

        return cell!
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddTransactionTableViewController : ProductsListTableViewControllerDelegate{
    func didSelectProduct(sender: ProductsListTableViewController, product: Product, selectedQuantity: Int) {
//        sender.navigationController?.popViewControllerAnimated(true);
        sender.dismissViewControllerAnimated(true, completion: nil);
        handleSelectedProduct(product, selectedQuantity: selectedQuantity);
    }
}
