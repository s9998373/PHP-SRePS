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
        
        let addButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(ProductsListTableViewController.addNewProduct));
        self.navigationItem.rightBarButtonItem = addButton;
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: kCellIdentifier)
        
        productList = SalesDataSource.sharedManager.allProducts();
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func addNewProduct(){
        let controller = self.storyboardReference!.instantiateViewControllerWithIdentifier("AddProductTableViewController") as! AddProductTableViewController
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
        return productList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier, forIndexPath: indexPath)
        
        // Configure the cell...
        
        let product = productList[indexPath.row];
        cell.textLabel?.text = product.name;
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
        
        return cell
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if delegate != nil {
            let selectedProduct: Product = productList[indexPath.row] as! Product;
            promptForQuantity(selectedProduct);
        }
    }
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ProductsListTableViewController : UITextFieldDelegate{
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet()) != nil {
            return false
        } else {
            return true
        }
    }
}
