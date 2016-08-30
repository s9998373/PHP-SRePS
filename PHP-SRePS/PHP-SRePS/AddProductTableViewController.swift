//
//  AddProductTableViewController.swift
//  PHP-SRePS
//
//  Created by Terry Lewis on 16/08/2016.
//  Copyright © 2016 swindp2. All rights reserved.
//

import UIKit

class AddProductTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.title = "Add Item";
        
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
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
    }
}
