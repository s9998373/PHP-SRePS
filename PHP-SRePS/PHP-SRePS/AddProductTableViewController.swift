//
//  AddProductTableViewController.swift
//  PHP-SRePS
//
//  Created by Terry Lewis on 16/08/2016.
//  Copyright © 2016 swindp2. All rights reserved.
//

import UIKit

class AddProductTableViewController: UITableViewController {
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
    
    func dismissController(){
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func addItem(){
//        print("Product name: ", self.productNameTextField.text, ". Product price: ", self.productPriceTextField.text, ".");
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
        }else{
            //failure, show a message
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
    }
}
