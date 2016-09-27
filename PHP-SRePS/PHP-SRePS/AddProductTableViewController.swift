//
//  AddProductTableViewController.swift
//  PHP-SRePS
//
//  Created by Terry Lewis on 16/08/2016.
//  Copyright © 2016 swindp2. All rights reserved.
//

import UIKit

protocol AddProductTableViewControllerDelegate: class {
    func didAddProduct(sender: AddProductTableViewController, product: Product)
}

class AddProductTableViewController: UITableViewController {
    weak var delegate: AddProductTableViewControllerDelegate!;
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let cancelButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(AddProductTableViewController.dismissController));
        self.navigationItem.leftBarButtonItem = cancelButtonItem;
        
        let addButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(AddProductTableViewController.addItem));
        self.navigationItem.rightBarButtonItem = addButtonItem;
        
        self.tableView.allowsSelection = false;
    }
    
    /// Generic view controller dismissal method.
    func dismissController(){
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    /// Adds the new product to the database.
    func addItem(){
        let name: String = self.productNameTextField.text!;
        let price: String = self.productPriceTextField.text!;
        
        if (name.characters.count == 0 || price.characters.count == 0) {
            let alert = UIAlertController.init(title: "Error", message: "A name and price must be specified.", preferredStyle: UIAlertControllerStyle.Alert);
            alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default, handler: nil));
            self.presentViewController(alert, animated: true, completion: nil);
            return;
        }
        
        let newProduct = Product(aName: name, aPrice: price);
        if SalesDataSource.sharedManager.addSalesProduct(newProduct){
            //success
            self.dismissController();
            self.delegate.didAddProduct(self, product: newProduct)
        }else{
            //failure, show a message
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
    }
}
