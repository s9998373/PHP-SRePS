//
//  ProductsListTableViewController.swift
//  PHP-SRePS
//
//  Created by Terry Lewis on 16/08/2016.
//  Copyright © 2016 swindp2. All rights reserved.
//

import UIKit

protocol ProductsListTableViewControllerDelegate: class {
    func didSelectProduct(sender: ProductsListTableViewController, product: Product, selectedQuantity: Int)
}

class ProductsListTableViewController: UITableViewController {
    
    var storyboardReference: UIStoryboard!;
    var productList: NSArray!;
    weak var delegate: ProductsListTableViewControllerDelegate!;
    let kCellIdentifier = "ProductCellIdentifier";
    
    convenience init(){
        self.init(style: UITableViewStyle.Grouped);
        self.title = "Products";
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(ProductsListTableViewController.dismiss));
        let addButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(ProductsListTableViewController.addNewProduct));
        self.navigationItem.rightBarButtonItem = addButton;
        self.navigationItem.leftBarButtonItem = cancelButton
        
        self.reloadData();
    }
    
    /// Reloads the data and table view.
    func reloadData(){
        productList = SalesDataSource.sharedManager.allProducts();
        self.tableView.reloadData();
    }
    
    /// Adds the new product that is actively being configured.
    func addNewProduct(){
        let controller = self.storyboardReference!.instantiateViewControllerWithIdentifier("AddProductTableViewController") as! AddProductTableViewController
        controller.delegate = self;
        let nav = UINavigationController.init(rootViewController: controller);
        self.presentViewController(nav, animated: true, completion: nil);
    }
    
    /// Generic view controller dismissmal method.
    func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (productList != nil) {
            return productList.count;
        }
        return 0;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell?
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: kCellIdentifier)
        }
        
        let product = productList[indexPath.row] as! Product;
        cell!.textLabel?.text = product.name;
        cell!.detailTextLabel?.text = product.localisedPrice();
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if delegate != nil {
            let selectedProduct: Product = productList[indexPath.row] as! Product;
            promptForQuantity(selectedProduct);
        }
    }
    
    /// Prompt the user to input a desired quantity.
    ///
    /// - parameter selectedProduct: The product that the quantity is being queried with regards to.
    func promptForQuantity(selectedProduct: Product){
        let alert = UIAlertController.init(title: "Quantity", message: "Select a quanity", preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
            self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow!, animated: true);
            let quantityString = alert.textFields?.first!.text;
            if quantityString?.characters.count > 0{
                let selectedQuantity: Int = Int((quantityString)!)!;
                self.delegate.didSelectProduct(self, product: selectedProduct, selectedQuantity: selectedQuantity);
            }
        }));
        alert.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction) in
            self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow!, animated: true);
        }));
        alert.addTextFieldWithConfigurationHandler { (textfield: UITextField) in
            textfield.delegate = self;
            textfield.keyboardType = UIKeyboardType.NumberPad;
        }
        self.presentViewController(alert, animated: true, completion: nil);
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let selectedProduct:Product = SalesDataSource.sharedManager.allProducts().objectAtIndex(indexPath.row) as! Product
            let salesEntries = SalesDataSource.sharedManager.allSalesEntries() as! [SalesEntry]
            var canBeDeleted = true
            for salesEntry in salesEntries{
                if salesEntry.product == selectedProduct {
                    canBeDeleted = false
                }
            }
            
            if canBeDeleted {
                SalesDataSource.sharedManager.removeSalesProduct(selectedProduct)
                reloadData()
            }else{
                let alert = UIAlertController.init(title: "Error", message: "This product cannot be deleted as it is referenced in other transactions. Remove all transactions referencing this product and then try again.", preferredStyle: UIAlertControllerStyle.Alert);
                alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default, handler: nil));
                self.presentViewController(alert, animated: true, completion: nil);
            }
        }
    }
    
}

extension ProductsListTableViewController : UITextFieldDelegate{
    
    /// Only allow integers in textField.
    ///
    /// - parameter textField: The textField in question.
    /// - parameter range:     The range of the string that is being affected.
    /// - parameter string:    The replacement characters.
    ///
    /// - returns: True is the given string should be added to the textField, otherwise, false.
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet()) != nil {
            return false
        } else {
            return true
        }
    }
}

extension ProductsListTableViewController : AddProductTableViewControllerDelegate{
    
    /// When a product is added, refresh the list of products.
    ///
    /// - parameter sender:  The controller that added the product.
    /// - parameter product: The new product.
    func didAddProduct(sender: AddProductTableViewController, product: Product) {
        self.reloadData();
    }
}
